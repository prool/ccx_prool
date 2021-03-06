!
!     CalculiX - A 3-dimensional finite element program
!              Copyright (C) 1998-2015 Guido Dhondt
!
!     This program is free software; you can redistribute it and/or
!     modify it under the terms of the GNU General Public License as
!     published by the Free Software Foundation(version 2);
!     
!
!     This program is distributed in the hope that it will be useful,
!     but WITHOUT ANY WARRANTY; without even the implied warranty of 
!     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
!     GNU General Public License for more details.
!
!     You should have received a copy of the GNU General Public License
!     along with this program; if not, write to the Free Software
!     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
!
      subroutine amplitudes(inpc,textpart,amname,amta,namta,nam,
     &  nam_,namtot_,irstrt,istep,istat,n,iline,ipol,inl,ipoinp,inp,
     &  ipoinpc)
!
!     reading the input deck: *AMPLITUDE
!
      implicit none
!
      logical user
!
      character*1 inpc(*)
      character*80 amname(*)
      character*132 textpart(16)
!
      integer namta(3,*),nam,nam_,istep,istat,n,key,i,namtot,
     &  namtot_,irstrt,iline,ipol,inl,ipoinp(2,*),inp(3,*),ipos,
     &  ipoinpc(0:*)
!
      real*8 amta(2,*),x,y
!
      user=.false.
!
      if((istep.gt.0).and.(irstrt.ge.0)) then
         write(*,*) '*ERROR reading *AMPLITUDE: *AMPLITUDE should be'
         write(*,*) '  placed before all step definitions'
         call exit(201)
      endif
!
      nam=nam+1
      if(nam.gt.nam_) then
         write(*,*) '*ERROR reading *AMPLITUDE: increase nam_'
         call exit(201)
      endif
      namta(3,nam)=nam
      amname(nam)='
     &                           '
!
      do i=2,n
         if(textpart(i)(1:5).eq.'NAME=') then
            amname(nam)=textpart(i)(6:85)
            if(textpart(i)(86:86).ne.' ') then
               write(*,*) '*ERROR reading *AMPLITUDE: amplitude'
               write(*,*) '      name is too long'
               write(*,*) '      (more than 80 characters)'
               write(*,*) '      amplitude name:',textpart(i)(1:132)
               call exit(201)
            endif
         elseif(textpart(i)(1:14).eq.'TIME=TOTALTIME') then
            namta(3,nam)=-nam
         elseif(textpart(i)(1:4).eq.'USER') then
            namta(1,nam)=0
            namta(2,nam)=0
            user=.true.
         elseif(textpart(i)(1:18).eq.'DEFINITION=TABULAR') then
            cycle
         elseif(textpart(i)(1:14).eq.'VALUE=RELATIVE') then
            cycle
         else
            write(*,*) 
     &        '*WARNING reading *AMPLITUDE: parameter not recognized:'
            write(*,*) '         ',
     &                 textpart(i)(1:index(textpart(i),' ')-1)
            call inputwarning(inpc,ipoinpc,iline,
     &"*AMPLITUDE%")
         endif
      enddo
!
      if(amname(nam).eq.'                                               
     &                                 ') then
         write(*,*) '*ERROR reading *AMPLITUDE: Amplitude has no name'
         call inputerror(inpc,ipoinpc,iline,
     &"*AMPLITUDE%")
      endif
!
      if(.not.user) then
         if(nam.eq.1) then
            namtot=0
         else
            namtot=namta(2,nam-1)
         endif
         namta(1,nam)=namtot+1
      endif
!
      do
         call getnewline(inpc,textpart,istat,n,key,iline,ipol,inl,
     &        ipoinp,inp,ipoinpc)
         if((istat.lt.0).or.(key.eq.1)) exit
         do i=1,4
            if(textpart(2*i-1)(1:1).ne.' ') then  
               namtot=namtot+1
               if(namtot.gt.namtot_) then
                  write(*,*) 
     &               '*ERROR reading *AMPLITUDE: increase namtot_'
                  call exit(201)
               endif
               read(textpart(2*i-1),'(f20.0)',iostat=istat) x
               if(istat.gt.0) call inputerror(inpc,ipoinpc,iline,
     &"*AMPLITUDE%")
               read(textpart(2*i),'(f20.0)',iostat=istat) y
               if(istat.gt.0) call inputerror(inpc,ipoinpc,iline,
     &"*AMPLITUDE%")
               amta(1,namtot)=x
               amta(2,namtot)=y
               namta(2,nam)=namtot
            else
               exit
            endif
         enddo
      enddo
!
      if(namta(1,nam).gt.namta(2,nam)) then
         ipos=index(amname(nam),' ')
         write(*,*) 
     &      '*WARNING reading *AMPLITUDE: *AMPLITUDE definition ',
     &       amname(nam)(1:ipos-1) 
         write(*,*) '         has no data points'
         nam=nam-1
      endif
!
      return
      end

