#####################################################################################
# Automatically generated by qmake (2.01a) Tue 2. Dec 10:46:50 2014
#####################################################################################
QT        += core gui opengl network
greaterThan(QT_MAJOR_VERSION, 4): QT         += widgets

TEMPLATE = app

greaterThan(QT_MAJOR_VERSION, 4) {
    QT *= printsupport
}

include(../gitversion.pri)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

TARGET +=
DEPENDPATH += .
INCLUDEPATH += .
INCLUDEPATH += ../lc_lib/common ../lc_lib/qt ../ldrawini ../ldglite
# If quazip is alredy installed you can suppress building it again by
# adding CONFIG+=quazipnobuild to the qmake arguments
# Update the quazip header path if not installed at default location below
quazipnobuild {
    INCLUDEPATH += /usr/include/quazip
} else {
    INCLUDEPATH += ../quazip
}

macx {
    CONFIG += c++11
} else {
    lessThan(QT_MAJOR_VERSION, 5): CONFIG += c++11
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

contains(QT_ARCH, x86_64) {
    ARCH = 64
} else {
    ARCH = 32
}

CONFIG += precompile_header
PRECOMPILED_HEADER += ../lc_lib/common/lc_global.h
QMAKE_CXXFLAGS_WARN_ON += -Wno-unused-parameter

win32 {

    DEFINES += _CRT_SECURE_NO_WARNINGS _CRT_SECURE_NO_DEPRECATE=1 _CRT_NONSTDC_NO_WARNINGS=1
    QMAKE_EXT_OBJ = .obj
    PRECOMPILED_SOURCE = ../lc_lib/common/lc_global.cpp
    CONFIG += windows
    LIBS += -ladvapi32 -lshell32
    greaterThan(QT_MAJOR_VERSION, 4): LIBS += -lz -lopengl32

    QMAKE_TARGET_COMPANY = "LPub3D Software"
    QMAKE_TARGET_DESCRIPTION = "An LDraw Building Instruction Editor."
    QMAKE_TARGET_COPYRIGHT = "Copyright (c) 2015-2017 Trevor SANDY"
    QMAKE_TARGET_PRODUCT = "LPub3D ($$ARCH-bit)"
    RC_LANG = "English (United Kingdom)"
    RC_ICONS = "lpub3d.ico"

} else {

    LIBS += -lz
    # Use installed quazip library
    quazipnobuild: LIBS += -lquazip

}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

lessThan(QT_MAJOR_VERSION, 5) {
    unix {
        GCC_VERSION = $$system(g++ -dumpversion)
        greaterThan(GCC_VERSION, 4.6) {
            QMAKE_CXXFLAGS += -std=c++11
        } else {
            QMAKE_CXXFLAGS += -std=c++0x
        }
     }
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

unix:!macx: TARGET = lpub3d
else: TARGET = LPub3D

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Note on x11 platforms you can also pre-install install quazip ($ sudo apt-get install libquazip-dev)
# If quazip is already installed, set CONFIG+=quazipnobuld to use installed library

CONFIG(debug, debug|release) {
    message("~~~ MAIN_APP DEBUG build ~~~")
    DEFINES += QT_DEBUG_MODE
    DESTDIR = debug
    macx {
        LDRAWINI_LIB = LDrawIni_debug
        QUAZIP_LIB = QuaZIP_debug
    }
    win32 {
        LDRAWINI_LIB = LDrawInid161
        QUAZIP_LIB = QuaZIPd07
    }
    unix:!macx {
        LDRAWINI_LIB = ldrawinid
        QUAZIP_LIB = quazipd
    }
    # library target name
    LIBS += -L$$DESTDIR/../../ldrawini/debug -l$$LDRAWINI_LIB
    !quazipnobuild: LIBS += -L$$DESTDIR/../../quazip/debug -l$$QUAZIP_LIB
    # executable target name
    win32: TARGET = $$join(TARGET,,,d$$VER_MAJOR$$VER_MINOR)
} else {
    message("~~~ MAIN_APP RELEASE build ~~~")
    DESTDIR = release
    unix:!macx {
        LIBS += -L$$DESTDIR/../../ldrawini/release -lldrawini
        !quazipnobuild: LIBS += -L$$DESTDIR/../../quazip/release -lquazip
    } else {
        win32 {
            LIBS += -L$$DESTDIR/../../ldrawini/release -lLDrawIni161
            !quazipnobuild: LIBS += -L$$DESTDIR/../../quazip/release -lQuaZIP07
        } else {
            LIBS += -L$$DESTDIR/../../ldrawini/release -lLDrawIni
            !quazipnobuild: LIBS += -L$$DESTDIR/../../quazip/release -lQuaZIP
        }
    }
    !macx: TARGET = $$join(TARGET,,,$$VER_MAJOR$$VER_MINOR)
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

static {                                      # everything below takes effect with CONFIG ''= static
    message("~~~ MAIN_APP STATIC build ~~~") # this is for information, that the static build is done
    CONFIG+= static
    LIBS += -static
    DEFINES += STATIC
    DEFINES += QUAZIP_STATIC                 # this is so the compiler can detect quazip static
    macx: TARGET = $$join(TARGET,,,_static)  # this adds an _static in the end, so you can seperate static build from non static build
    win32: TARGET = $$join(TARGET,,,s)       # this adds an s in the end, so you can seperate static build from non static build
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

OBJECTS_DIR = $$DESTDIR/.obj
MOC_DIR     = $$DESTDIR/.moc
RCC_DIR     = $$DESTDIR/.qrc
UI_DIR      = $$DESTDIR/.ui

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
unix:!macx {

    # For compiled builds on unix set C++11 standard appropriately
    GCC_VERSION = $$system(g++ -dumpversion)
    greaterThan(GCC_VERSION, 4.6) {
        QMAKE_CXXFLAGS += -std=c++11
    } else {
        QMAKE_CXXFLAGS += -std=c++0x
    }

    binarybuild {
        # To build a binary distribution that will not require elevated rights to install,
        # pass CONFIG+=binarybuild to qmake (i.e. in QtCreator, set in qmake Additional Arguments)
        # The installer which uses Qt installer framework can be found in the "builds" source folder.
        # This macro is used to properly load parameter files on initial launch
        DEFINES += X11_BINARY_BUILD
        # Linker flag setting to properly direct LPub3D to ldrawini and quazip shared libraries.
        # This setting assumes dependent libraries are deposited at <exe location>/lib by the installer.
        QMAKE_LFLAGS += "-Wl,-rpath,\'\$$ORIGIN/lib\'"

    }

    # These defines point LPub3D to the architecture appropriate content
    # when performing 'check for update' download and installation
    # Don't forget to set CONFIG+=<deb|rpm|pkg> accordingly if NOT using
    # the accompanying build scripts - CreateDeb.sh, CreateRpm.sh or CreatePkg.sh
    deb: PACKAGE_TYPE = DEB_DISTRO
    rpm: PACKAGE_TYPE = RPM_DISTRO
    pkg: PACKAGE_TYPE = PKG_DISTRO
    !isEmpty(PACKAGE_TYPE): DEFINES += $$PACKAGE_TYPE

    MAN_PAGE = lpub3d$$VER_MAJOR$$VER_MINOR
    MAN_PAGE = $$join(MAN_PAGE,,,.1)

    # These settings are used for package distributions that will require elevated rights to install
    isEmpty(INSTALL_PREFIX):INSTALL_PREFIX = /usr
    isEmpty(BIN_DIR):BIN_DIR = $$INSTALL_PREFIX/bin
    isEmpty(DOCS_DIR):DOCS_DIR = $$INSTALL_PREFIX/share/doc/lpub3d
    isEmpty(ICON_DIR):ICON_DIR = $$INSTALL_PREFIX/share/pixmaps
    isEmpty(MAN_DIR):MAN_DIR = $$INSTALL_PREFIX/share/man/man1
    isEmpty(DESKTOP_DIR):DESKTOP_DIR = $$INSTALL_PREFIX/share/applications
    isEmpty(MIME_DIR):MIME_DIR = $$INSTALL_PREFIX/share/mime/packages
    isEmpty(MIME_ICON_DIR):MIME_ICON_DIR = $$INSTALL_PREFIX/share/icons/hicolor/scalable/mimetypes
    isEmpty(RESOURCE_DIR):RESOURCE_DIR = $$INSTALL_PREFIX/share/lpub3d
    isEmpty(LDGLITE_DIR):LDGLITE_DIR = $$INSTALL_PREFIX/share/lpub3d/3rdParty/bin
    isEmpty(LDGLITE_DOC_DIR):LDGLITE_DOC_DIR = $$INSTALL_PREFIX/share/doc/lpub3d/3rdParty/ldglite
    isEmpty(LDGLITE_RES_DIR):LDGLITE_RES_DIR = $$INSTALL_PREFIX/share/lpub3d/3rdParty/ldglite
    isEmpty(LDVIEW_DIR):LDVIEW_DIR = $$INSTALL_PREFIX/share/lpub3d/3rdParty/bin
    isEmpty(LDVIEW_RES_DIR):LDVIEW_RES_DIR = $$INSTALL_PREFIX/share/lpub3d/3rdParty/ldview
    isEmpty(LDVIEW_DOC_DIR):LDVIEW_DOC_DIR = $$INSTALL_PREFIX/share/doc/lpub3d/3rdParty/ldview

    target.path = $$BIN_DIR

    docs.files += docs/README.txt docs/CREDITS.txt docs/COPYING.txt
    docs.path = $$DOCS_DIR

    man.files += $$MAN_PAGE
    man.path = $$MAN_DIR

    desktop.files += lpub3d.desktop
    desktop.path = $$DESKTOP_DIR

    icon.files += images/lpub3d.png
    icon.path = $$ICON_DIR

    mime.files += lpub3d.xml
    mime.path = $$MIME_DIR

    mime_ldraw_icon.files += images/x-ldraw.svg
    mime_ldraw_icon.path = $$MIME_ICON_DIR

    mime_multi_part_ldraw_icon.files += images/x-multi-part-ldraw.svg
    mime_multi_part_ldraw_icon.path = $$MIME_ICON_DIR

    mime_multipart_ldraw_icon.files += images/x-multipart-ldraw.svg
    mime_multipart_ldraw_icon.path = $$MIME_ICON_DIR

    excluded_count_parts.files += extras/excludedParts.lst
    excluded_count_parts.path = $$RESOURCE_DIR

    fadestep_color_parts.files += extras/fadeStepColorParts.lst
    fadestep_color_parts.path = $$RESOURCE_DIR

    pli_freeform_annotations.files += extras/freeformAnnotations.lst
    pli_freeform_annotations.path = $$RESOURCE_DIR

    pli_title_annotations.files += extras/titleAnnotations.lst
    pli_title_annotations.path = $$RESOURCE_DIR

    pli_orientation.files += extras/pli.mpd
    pli_orientation.path = $$RESOURCE_DIR

    pli_substitution_parts.files += extras/pliSubstituteParts.lst
    pli_substitution_parts.path = $$RESOURCE_DIR

    ldraw_unofficial_library.files += extras/lpub3dldrawunf.zip
    ldraw_unofficial_library.path = $$RESOURCE_DIR

    ldraw_official_library.files += extras/complete.zip
    ldraw_official_library.path = $$RESOURCE_DIR

    # renderers
    CONFIG(release, debug|release) {
        ldglite.files += $$DESTDIR/../../ldglite/release/ldglite
        ldglite.path = $$LDGLITE_DIR

        ldview.files += ../builds/3rdParty/bin/macx/ldview/ldview
        ldview.path = $$LDVIEW_DIR
    }
    ldglite_docs.files += ../ldglite/ldglite.1 ../ldglite/doc/README.TXT ../ldglite/doc/LICENCE
    ldglite_docs.path = $$LDGLITE_DOC_DIR

    liglite_resources.files += ../ldglite/ldglite_osxwrapper.sh
    ldglite_resources.path = $$LDGLITE_RES_DIR

    ldview_docs.files += \
         ../builds/3rdParty/docs/ldview-4.3/HELP.HTML \
         ../builds/3rdParty/docs/ldview-4.3/README.TXT \
         ../builds/3rdParty/docs/ldview-4.3/LICENSE.TXT \
         ../builds/3rdParty/docs/ldview-4.3/CHANGEHISTORY.HTML
    ldview_docs.path = $$LDVIEW_DOC_DIR

    ldview_resources.files += \
          ../builds/3rdParty/resources/ldview-4.3/LDExportMessages.ini \
          ../builds/3rdParty/resources/ldview-4.3/LDViewMessages.ini \
          ../builds/3rdParty/resources/ldview-4.3/SansSerif.fnt \
          ../builds/3rdParty/resources/ldview-4.3/ldviewrc \
          ../builds/3rdParty/resources/ldview-4.3/StudLogo.png \
          ../builds/3rdParty/resources/ldview-4.3/StudLogo.psd \
          ../builds/3rdParty/resources/ldview-4.3/8464.mpd \
          ../builds/3rdParty/resources/ldview-4.3/m6459.ldr
    ldview_resources.path = $$LDVIEW_RES_DIR

    INSTALLS += \
    target \
    docs \
    man \
    desktop \
    icon\
    mime\
    mime_ldraw_icon \
    mime_multi_part_ldraw_icon \
    mime_multipart_ldraw_icon \
    excluded_count_parts \
    fadestep_color_parts \
    pli_freeform_annotations \
    pli_title_annotations \
    pli_orientation \
    pli_substitution_parts \
    ldraw_unofficial_library \
    ldraw_official_library \
    ldglite_docs \
    ldglite_resources \
    ldview_docs \
    ldview_resources
    CONFIG(release, debug|release) {
        INSTALLS += \
        ldglite \
        ldview
    }

    DEFINES += LC_INSTALL_PREFIX=\\\"$$INSTALL_PREFIX\\\"

    !isEmpty(DISABLE_UPDATE_CHECK) {
            DEFINES += LC_DISABLE_UPDATE_CHECK=$$DISABLE_UPDATE_CHECK
    }

    !isEmpty(LDRAW_LIBRARY_PATH) {
            DEFINES += LC_LDRAW_LIBRARY_PATH=\\\"$$LDRAW_LIBRARY_PATH\\\"
    }
}

macx {

    ICON = lpub3d.icns
    QMAKE_INFO_PLIST = Info.plist

    document_icon.files += ldraw_document.icns
    document_icon.path = Contents/Resources

    document_readme.files += docs/README.txt
    document_readme.path = Contents/Resources

    document_credits.files += docs/CREDITS.txt
    document_credits.path = Contents/Resources

    document_copying.files += docs/COPYING.txt
    document_copying.path = Contents/Resources

    excluded_count_parts.files += extras/excludedParts.lst
    excluded_count_parts.path = Contents/Resources

    fadestep_color_parts.files += extras/fadeStepColorParts.lst
    fadestep_color_parts.path = Contents/Resources

    pli_freeform_annotations.files += extras/freeformAnnotations.lst
    pli_freeform_annotations.path = Contents/Resources

    pli_title_annotations.files += extras/titleAnnotations.lst
    pli_title_annotations.path = Contents/Resources

    pli_orientation.files += extras/pli.mpd
    pli_orientation.path = Contents/Resources

    pli_substitution_parts.files += extras/pliSubstituteParts.lst
    pli_substitution_parts.path = Contents/Resources

    ldraw_unofficial_library.files += extras/lpub3dldrawunf.zip
    ldraw_unofficial_library.path = Contents/Resources

    ldraw_official_library.files += extras/complete.zip
    ldraw_official_library.path = Contents/Resources

    # renderers
#    CONFIG(release, debug|release) {
#        ldglite.files += $$DESTDIR/../../ldglite/release/ldglite.app
#        ldglite.path = Contents/3rdParty/bin

#        ldview.files += ../builds/3rdParty/bin/macx/ldview-4.3/ldview.app
#        ldview.path = Contents/3rdParty/bin
#    }

#    ldglite_docs.files += ../ldglite/doc/ldglite.1 ../ldglite/doc/README.TXT ../ldglite/doc/LICENCE
#    ldglite_docs.path = Contents/3rdParty/docs/ldglite

#    liglite_resources.files += ../ldglite/ldglite_osxwrapper.sh
#    ldglite_resources.path = Contents/3rdParty/resources/ldglite

#    ldview_docs.files += \
#         ../builds/3rdParty/docs/ldview-4.3/HELP.HTML \
#         ../builds/3rdParty/docs/ldview-4.3/README.TXT \
#         ../builds/3rdParty/docs/ldview-4.3/LICENSE.TXT \
#         ../builds/3rdParty/docs/ldview-4.3/CHANGEHISTORY.HTML
#    ldview_docs.path = Contents/3rdParty/docs/ldvieW

#    ldview_resources.files += \
#          ../builds/3rdParty/resources/ldview-4.3/LDExportMessages.ini \
#          ../builds/3rdParty/resources/ldview-4.3/LDViewMessages.ini \
#          ../builds/3rdParty/resources/ldview-4.3/SansSerif.fnt \
#          ../builds/3rdParty/resources/ldview-4.3/ldviewrc \
#          ../builds/3rdParty/resources/ldview-4.3/StudLogo.png \
#          ../builds/3rdParty/resources/ldview-4.3/StudLogo.psd \
#          ../builds/3rdParty/resources/ldview-4.3/8464.mpd \
#          ../builds/3rdParty/resources/ldview-4.3/m6459.ldr
#    ldview_resources.path = Contents/3rdParty/resources/ldview

    # libraries
    CONFIG(release, debug|release) {
        libquazip.files += \
            $$DESTDIR/../../quazip/release/libQuaZIP.0.dylib
        libquazip.path = Contents/Libs

        libldrawini.files += \
            $$DESTDIR/../../ldrawini/release/libLDrawIni.16.dylib
        libldrawini.path = Contents/Libs
    }

    QMAKE_BUNDLE_DATA += \
        document_icon \
        document_readme \
        document_credits \
        document_copying \
        excluded_count_parts \
        fadestep_color_parts \
        pli_freeform_annotations \
        pli_title_annotations \
        pli_orientation \
        pli_substitution_parts \
        ldraw_unofficial_library \
        ldraw_official_library #\
#        ldview_docs \
#        ldview_resources \
#        ldglite_docs \
#        ldglite_resources
    CONFIG(release, debug|release) {
    QMAKE_BUNDLE_DATA += \
        libquazip \
        libldrawini #\
#        ldglite \
#        ldview
     }


}

#~~ includes ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

include(../lc_lib/lc_lib.pri)
include(../qslog/QsLog.pri)
include(../qsimpleupdater/QSimpleUpdater.pri)
include(../LPub3DPlatformSpecific.pri)

#~~ inputs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

HEADERS += \
    aboutdialog.h \
    application.h \
    annotations.h \
    archiveparts.h \
    backgrounddialog.h \
    backgrounditem.h \
    borderdialog.h \
    callout.h \
    calloutbackgrounditem.h \
    color.h \
    commands.h \
    commonmenus.h \
    csiitem.h \
    dependencies.h \
    dialogexportpages.h \
    dividerdialog.h \
    editwindow.h \
    excludedparts.h \
    fadestepcolorparts.h \
    globals.h \
    gradients.h \
    highlighter.h \
    hoverpoints.h \
    ldrawfiles.h \
    ldsearchdirs.h \
    lpub.h \
    lpub_preferences.h \
    meta.h \
    metagui.h \
    metaitem.h \
    metatypes.h \
    name.h \
    numberitem.h \
    pagebackgrounditem.h \
    pageattributetextitem.h \
    pageattributepixmapitem.h \
    pairdialog.h \
    pageorientationdialog.h \
    pagesizedialog.h \
    parmshighlighter.h \
    parmswindow.h \
    paths.h \
    placement.h \
    placementdialog.h \
    pli.h \
    pliannotationdialog.h \
    pliconstraindialog.h \
    plisortdialog.h \
    plisubstituteparts.h \
    pointer.h \
    pointeritem.h \
    preferencesdialog.h \
    range.h \
    range_element.h \
    ranges.h \
    ranges_element.h \
    ranges_item.h \
    render.h \
    reserve.h \
    resize.h \
    resolution.h \
    rotateiconitem.h \
    rx.h \
    scaledialog.h \
    step.h \
    textitem.h \
    threadworkers.h \
    updatecheck.h \
    where.h \
    sizeandorientationdialog.h \
    version.h

SOURCES += \
    aboutdialog.cpp \
    application.cpp \
    annotations.cpp \
    archiveparts.cpp \
    assemglobals.cpp \
    backgrounddialog.cpp \
    backgrounditem.cpp \
    borderdialog.cpp \
    callout.cpp \
    calloutbackgrounditem.cpp \
    calloutglobals.cpp \
    color.cpp \
    commands.cpp \
    commonmenus.cpp \
    csiitem.cpp \
    dependencies.cpp \
    dialogexportpages.cpp \
    dividerdialog.cpp \
    editwindow.cpp \
    excludedparts.cpp \
    fadestepcolorparts.cpp \
    fadestepglobals.cpp \
    formatpage.cpp \
    gradients.cpp \
    highlighter.cpp \
    hoverpoints.cpp \
    ldrawfiles.cpp \
    ldsearchdirs.cpp \
    lpub.cpp \
    lpub_preferences.cpp \
    meta.cpp \
    metagui.cpp \
    metaitem.cpp \
    multistepglobals.cpp \
    numberitem.cpp \
    openclose.cpp \
    pagebackgrounditem.cpp \
    pageattributetextitem.cpp \
    pageattributepixmapitem.cpp \
    pageglobals.cpp \
    pageorientationdialog.cpp \
    pagesizedialog.cpp \
    pairdialog.cpp \
    parmshighlighter.cpp \
    parmswindow.cpp \
    paths.cpp \
    placement.cpp \
    placementdialog.cpp \
    pli.cpp \
    pliannotationdialog.cpp \
    pliconstraindialog.cpp \
    pliglobals.cpp \
    plisortdialog.cpp \
    plisubstituteparts.cpp \
    pointeritem.cpp \
    preferencesdialog.cpp \
    printfile.cpp \
    projectglobals.cpp \
    range.cpp \
    range_element.cpp \
    ranges.cpp \
    ranges_element.cpp \
    ranges_item.cpp \
    render.cpp \
    resize.cpp \
    resolution.cpp \
    rotateiconitem.cpp \
    rotate.cpp \
    rx.cpp \
    scaledialog.cpp \
    sizeandorientationdialog.cpp \
    step.cpp \
    textitem.cpp \
    threadworkers.cpp \
    traverse.cpp \
    updatecheck.cpp \
    undoredo.cpp

FORMS += \
    preferences.ui \
    aboutdialog.ui \
    dialogexportpages.ui

OTHER_FILES += \
    Info.plist \
    lpub3d.desktop \
    lpub3d.xml \
    lpub3d.sh \
    $$MAN_PAGE \
    ../builds/macx/CreateDmg.sh \
    ../builds/linux/CreateRpm.sh \
    ../builds/linux/CreateDeb.sh \
    ../builds/linux/CreatePkg.sh \
    ../builds/linux/obs/_service \
    ../builds/linux/obs/lpub3d.spec \
    ../builds/linux/obs/PKGBUILD \
    ../builds/linux/obs/debian/rules \
    ../builds/linux/obs/debian/control \
    ../builds/linux/obs/debian/copyright \
    ../builds/linux/obs/debian/lpub3d.dsc \
    ../builds/linux/obs/_service \
    ../builds/windows/setup/CreateExe.bat \
    ../builds/windows/setup/LPub3DNoPack.nsi \
    ../builds/windows/setup/nsisFunctions.nsh \
    ../builds/utilities/Copyright-Source-Headers.txt \
    ../builds/utilities/update-config-files.sh \
    ../builds/utilities/update-config-files.bat \
    ../builds/utilities/README.md \
    ../README.md \
    ../.gitignore \
    ../.travis.yml

RESOURCES += \
    lpub3d.qrc

DISTFILES += \
    ldraw_document.icns

#message($$CONFIG)


