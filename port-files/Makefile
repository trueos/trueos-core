# $FreeBSD$

PORTNAME=	trueos-core
PORTVERSION=	%%CHGVERSION%%
CATEGORIES=	misc
MASTER_SITES=
DISTFILES=

MAINTAINER=	jmaloney@ixsystems.com
COMMENT=	TrueOS Core Utilities

RUN_DEPENDS=	${LOCALBASE}/bin/pc-updatemanager:sysutils/pc-updatemanager \
		${LOCALBASE}/sbin/pc-sysinstall:sysutils/pc-sysinstall \
		${LOCALBASE}/share/trueos/scripts/functions.sh:sysutils/trueos-libsh \
		${LOCALBASE}/bin/lpreserver:sysutils/life-preserver \
		${LOCALBASE}/bin/sysadm-binary:sysutils/sysadm \
		${LOCALBASE}/sbin/beadm:sysutils/beadm \
		${LOCALBASE}/bin/rsync:net/rsync \
		${LOCALBASE}/bin/zfs-stats:sysutils/zfs-stats \
		bsdstats>=0:sysutils/bsdstats \
		ataidle>=0:sysutils/ataidle \
		openntpd>=0:net/openntpd \
		bhyve-firmware>=0:sysutils/bhyve-firmware \
		dhcpcd>=0:net/dhcpcd

CONFLICTS=	pcbsd-utils-[0-9]*
WRKSRC_SUBDIR=	package-files
MAKE_ARGS=	STAGEDIR=${STAGEDIR}

USE_GITHUB=     yes
GH_ACCOUNT=     trueos
GH_PROJECT=     trueos-core
GH_TAGNAME=     %%GHTAG%%

.include <bsd.port.mk>
