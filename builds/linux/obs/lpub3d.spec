#
# spec file for package lpub3d
#
# Copyright © 2017 Trevor SANDY
# Adapted from RPM Spec file examples by Thomas Baumgart and Peter Bartfai
# This file and all modifications and additions to the pristine
# package are under the same license as the package itself.
#
# please send bugfixes or comments to Trevor SANDY <trevor.sandy@gmail.com>
#

# set OBS environment
%if "%{vendor}" == "obs://build.opensuse.org/home:trevorsandy"
%define OBS 1
%endif

%if "%{vendor}" == "obs://private/home:trevorsandy"
%define OBS 1
%endif

# define distributions
%if 0%{?suse_version}
%define dist opensuse
%endif

%if 0%{?sles_version}
%define dist suse
%endif

%if 0%{?fedora}
%define dist fedora
%endif

%if 0%{?mdkversion}
%define dist manmdriva
%endif

%if 0%{?scientificlinux_version}
%define dist scientific
%endif

%if 0%{?rhel_version}
%define dist redhat
%endif

%if 0%{?centos_ver}
%define centos_version %{centos_ver}00
%define dist centos
%endif

# disable before release
%define UBUNTU_DEVENV 1
%if 0%{?UBUNTU_DEVENV}
	%define dist devenv
%endif

# packer's identification
%define packer %(finger -lp `echo "$USER"` | head -n 1 | cut -d: -f 3)

# distro group settings
%if 0%{?suse_version} || 0%{?sles_version}
Group: Productivity/Graphics/Viewers
%endif
%if 0%{?mdkversion} || 0%{?rhel_version} 
Group: Graphics
%endif
%if 0%{?suse_version} || 0%{?sles_version}
License: GPL-3.0+
BuildRequires: fdupes
%endif
%if 0%{?UBUNTU_DEVENV} || 0%{?fedora} || 0%{?centos_version}
Group: Amusements/Graphics
%endif
%if 0%{?UBUNTU_DEVENV} || 0%{?mdkversion} || 0%{?rhel_version} || 0%{?fedora} || 0%{?centos_version} || 0%{?scientificlinux_version}
License: GPLv3+
%endif

# package attributes
Name: lpub3d
Icon: lpub3d.xpm
Summary: An LDraw Building Instruction Editor
Version: 2.0.20
Release: 1%{?dist}
URL: https://github.com/trevorsandy/lpub3d
Vendor: Trevor SANDY
Packager: %packer
BuildRoot: %{_builddir}/%{name}
BuildArch: %{_arch}
Requires: unzip 
Source0: lpub3d.tar.gz

%if 0%{?UBUNTU_DEVENV}
Requires: qtbase5-dev qt5-qmake rpm
%endif

# package requirements
%if 0%{?fedora} || 0%{?rhel_version} || 0%{?centos_version} || 0%{?scientificlinux_version}
BuildRequires: qt5-qtbase-devel
%if 0%{?OBS}!=1
BuildRequires: git
%endif
BuildRequires: gcc-c++, make
%endif

%if 0%{?fedora}
%if 0%{?OBS}
BuildRequires: samba4-libs
%if 0%{?fedora_version}==22
BuildRequires: qca
%endif
%if 0%{?fedora_version}==23
BuildRequires: qca, gnu-free-sans-fonts
%endif
%endif
%endif

%if 0%{?suse_version} 
BuildRequires: libqt5-qtbase-devel, zlib-devel
%if 0%{?OBS}
BuildRequires: -post-build-checks
%endif
%endif

%if 0%{?sles_version}
%if 0%{?OBS}
BuildRequires: -post-build-checks
%endif
%endif

%description
 LPub3D is an Open Source WYSIWYG editing application for creating 
 LEGO® style digital building instructions. LPub3D is developed and 
 maintained by Trevor SANDY. It uses the LDraw™ parts library, the 
 most comprehensive library of digital Open Source LEGO® bricks 
 available (www.ldraw.org/ ) and reads the LDraw LDR and MPD model 
 file formats. LPub3D is available for free under the GNU Public License v3 
 and runs on Windows, Linux and OSX Operating Systems.
 Portions of LPub3D are based on LPUB© 2007-2009 Kevin Clague, 
 LeoCAD© 2015 Leonardo Zide.and additional third party components.
 LEGO® is a trademark of the LEGO Group of companies which does not 
 sponsor, authorize or endorse this application.
 © 2015-2017 Trevor SANDY

if [ -f lpub3d-*.tar.gz ] ; then 
	mvlpub3d-*.tar.gz lpub3d	
else
	ls
	git clone https://github.com/trevorsandy/lpub3d.git lpub3d
	tar -czvf lpub3d.tar.gz lpub3d \
	  --exclude="lpub3d/tools" \
	  --exclude="lpub3d/builds/linux/standard" \
	  --exclude="lpub3d/builds/osx" \
	  --exclude="lpub3d/.git" \
	  --exclude="lpub3d/LPub3D.pro.user" \
	  --exclude="lpub3d/LPub3Dx11.pro.user" \
	  --exclude="lpub3d/.gitignore"
fi

%prep
%autosetup -n %{name}

%build
export QT_SELECT=qt5

# get ldraw archive libraries
wget --directory-prefix=$RPM_BUILD_DIR/lpub3d/mainApp/extras \
		http://www.ldraw.org/library/updates/complete.zip
wget --directory-prefix=$RPM_BUILD_DIR/lpub3d/mainApp/extras \
		http://www.ldraw.org/library/unofficial/ldrawunf.zip
mv $RPM_BUILD_DIR/lpub3d/mainApp/extras/ldrawunf.zip 		 \
   $RPM_BUILD_DIR/lpub3d/mainApp/extras/lpub3dldrawunf.zip
	
# use Qt5
%if 0%{?fedora}==23
%ifarch x86_64
export Q_CXXFLAGS="$Q_CXXFLAGS -fPIC"
%endif
%endif
if which qmake-qt5 >/dev/null 2>/dev/null ; then 		\
    qmake-qt5 -makefile -nocache QMAKE_STRIP=: CONFIG+=release CONFIG+=rpm; \
else													\
    qmake -makefile -nocache QMAKE_STRIP=: CONFIG+=release CONFIG+=rpm; 	\
fi ;													\
make clean
make %{?_smp_mflags}

%install
make INSTALL_ROOT=%buildroot install

%clean
rm -rf $RPM_BUILD_ROOT

%files
%if 0%{?sles_version} || 0%{?suse_version}
%defattr(-,root,root)
%endif
%{_bindir}/*
%{_libdir}/*
%{_datadir}/*
%{_mandir}/man1/*

%post
/sbin/ldconfig
%postun
/sbin/ldconfig

%changelog
* Sun Jan 15 2017 - trevor.dot.sandy.at.gmail.dot.com 2.0.20
- Initial release