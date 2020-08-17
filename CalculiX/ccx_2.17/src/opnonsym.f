!
!     CalculiX - A 3-dimensional finite element program
!              Copyright (C) 1998-2020 Guido Dhondt
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
C
C-----MATRIX-VECTOR MULTIPLY FOR REAL SPARSE NONSYMMETRIC MATRICES---------
c     matrix storage:
c        au: nondiagonal terms, column by column
c        ad: diagonal terms
C
      SUBROUTINE OPNONSYM(n,p,W,U,ad,au,jq,irow)
      implicit real*8(a-h,o-z)
!     
C-----------------------------------------------------------------------
      integer  IROW(*),JQ(*),n
      real*8   U(*),W(*),Au(*),AD(*),p(*)
C-----------------------------------------------------------------------
C>     SPARSE MATRIX-VECTOR MULTIPLY FOR LANCZS  U = A*W
C>     SEE USPEC SUBROUTINE FOR DESCRIPTION OF THE ARRAYS THAT DEFINE
C>     THE MATRIX
!     the vector p is not needed but is kept for compatibility reasons
!     with the calling program
C-----------------------------------------------------------------------
C     
C     COMPUTE THE DIAGONAL TERMS
      DO 10 I = 1,N
         U(I) = AD(I)*W(I)
 10   CONTINUE
C     
C     COMPUTE BY COLUMN
      LLAST = 0
      DO 30 J = 1,N
C     
         DO 20 L = JQ(J),JQ(J+1)-1
            I = IROW(L)
C     
            U(I) = U(I) + Au(L)*W(J)
C     
 20      CONTINUE
C     
 30   CONTINUE
C     
      RETURN
      END
      



