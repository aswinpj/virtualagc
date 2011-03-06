### FILE="Main.annotation"
# Copyright:    Public domain.
# Filename:	S-BAND_ANTENNA_FOR_CM.agc
# Purpose:      Part of the source code for Colossus build 237.
#               This is for the Command Module's (CM) Apollo Guidance
#               Computer (AGC), we believe for Apollo 8.
# Assembler:    yaYUL
# Contact:      Jim Lawton <jim DOT lawton AT gmail DOT com>
# Website:      www.ibiblio.org/apollo/index.html
# Page scans:   www.ibiblio.org/apollo/ScansForConversion/Colossus237/
# Mod history:  2011-03-06 JL	Adapted from corresponding Colossus 249 file.

## Page 884
# S-BAND ANTENNA FOR CM

		BANK	23
		SETLOC	SBAND
		BANK

		COUNT*	$$/R05
		EBANK=	EMSALT

SBANDANT	TC	BANKCALL	# V 64 E GETS US HERE
		CADR	R02BOTH		# CHECK IF IMU IS ON AND ALIGNED
		TC	INTPRET
		RTB	CALL
			LOADTIME	# PICKUP CURRENT TIME SCALED B-28
			CDUTRIG		# COMPUTE SINES AND COSINES OF CDU ANGLES
		STCALL	TDEC1		# ADVANCE INTEGRATION TO TIME IN TDEC1
			CSMCONIC	# USING CONIC INTEGRATION
		SLOAD	BHIZ		# ORIGIN OF REFERENCE INERTIAL SYSTEM IS
			X2		# EARTH = 0, MOON = 2
			EISOI
		VLOAD
			RATT
		STORE	RCM		# MOVE RATT TO PREVENT WIPEOUT
		DLOAD	CALL		# MOON, PUSH ON
			TAT		# GET ORIGINAL TIME
			LUNPOS		# COMPUTE POSITION VECTOR OF MOON
		VAD	VCOMP		# R= -(REM+RCM) = NEG. OF S/C POS. VEC
			RCM
		GOTO
			EISOI +2
EISOI		VLOAD	VCOMP		# EARTH, R= -RCM
			RATT
		SETPD	MXV		# RCS TO STABLE MEMBER- B-1X B-29X B+1
			2D		# 2D
			REFSMMAT	# STABLE MEMBER.  B-1X B-29X B+1= B-29
		VSL1	PDDL		# 8D
			HI6ZEROS
		STOVL	YAWANG		# ZERO OUT YAWANG, SET UP FOR SMNB
			RCM		# TRANSFORMATION. SM COORD. SCALED B-29
		CALL
			*SMNB*
		STORE	R		# SAVE NAV. BASE COORDINATES
		UNIT	PDVL		# 14D
			R
		VPROJ	VSL2		# COMPUTE PROJECTION OF VECTOR INTO CM
			HIUNITZ		# XY-PLANE, R-(R.UZ)UZ
		BVSU	BOV		# CLEAR OVERFLOW INDICATOR IF SET
			R
			COVCNV
COVCNV		UNIT	BOV		# TEST OVERFLOW FOR INDICATION OF NULL
			NOADJUST	# VECTOR
		PUSH	DOT		# 20D
## Page 885
			HIUNITX		# COMPUTE YAW ANGLE = ACOS (URP.UX)
		SL1	ACOS		# REVOLUTIONS SCALED B0
		PDVL	DOT		# 22D YAWANG
			URP
			HIUNITY		# COMPUTE FOLLOWING- URP.UY
		SL1	BPL		# POSITIVE
			NOADJUST	# YES, 0- 180 DEGREES
		DLOAD	DSU		# NO, 181-360 DEGREES 20D
			DPPOSMAX	# COMPUTE 2 PI MINUS YAW ANGLE
		PUSH			# 22D YAWANG
NOADJUST	VLOAD	DOT		# COMPUTE PITCH ANGLE
			UR		# ACOS (UR.UZ) - PI/2
			HIUNITZ
		SL1	ACOS		# REVOLUTIONS B0
		DSU
			HIDP1/4
		STODL	RHOSB
			YAWANG
		STORE	GAMMASB		# PATCH FOR CHECKOUT
		EXIT
		CA	EXTVBACT	# IS BIT 5 STILL ON
		MASK	BIT5
		EXTEND
		BZF	ENDEXT		# NO, WE HAVE BEEN ANSWERED
		CAF	V06N51		# DISPLAY ANGLES
		TC	BANKCALL
		CADR	GOMARKFR
		TC	B5OFF		# TERMINATE
		TC	B5OFF
		TC	ENDOFJOB	# RECYCLE
		CAF	BIT3		# IMMEDIATE RETURN
		TC	BLANKET		# BLANK R3
		CAF	BIT1		# DELAY MINIMUM TIME TO ALLOW DISPLAY IN
		TC	BANKCALL
		CADR	DELAYJOB
		TCF	SBANDANT +2
V06N51		VN	0651
RCM		EQUALS	2D
UR		EQUALS	8D
URP		EQUALS	14D
YAWANG		EQUALS	20D
PITCHANG	EQUALS	22D
R		EQUALS	RCM
