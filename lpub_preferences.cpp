/**************************************************************************** 
**
** Copyright (C) 2007-2009 Kevin Clague. All rights reserved.
**
** This file may be used under the terms of the GNU General Public
** License version 2.0 as published by the Free Software Foundation
** and appearing in the file LICENSE.GPL included in the packaging of
** this file.  Please review the following information to ensure GNU
** General Public Licensing requirements will be met:
** http://www.trolltech.com/products/qt/opensource.html
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
**
****************************************************************************/
#include <QSettings>
#include <QFileInfo>
#include <QProcess>
#include <QString>
#include <QStringList>
#include <QDir>
#include <QFileDialog>
#include <QMessageBox>

#include "lpub_preferences.h"
#include "render.h"
#include "ui_preferences.h"
#include "preferencesdialog.h"
#include "name.h"
#include "resolution.h"
//**3D
#include "lc_global.h"
//**

#define DEBUG
#ifndef DEBUG
#define PRINT(x)
#else
#define PRINT(x) \
    std::cout << "- " << x << std::endl; //without expression
#endif

Preferences preferences;

QString Preferences::ldrawPath = " ";
QString Preferences::lgeoPath;
QString Preferences::lpubPath = ".";
QString Preferences::ldgliteExe;
QString Preferences::ldviewExe;
QString Preferences::l3pExe;
QString Preferences::povrayExe;
QString Preferences::pliFile;
QString Preferences::preferredRenderer;
QString Preferences::fadeStepColor;
bool    Preferences::preferCentimeters = false;
bool    Preferences::enableFadeStep = false;


Preferences::Preferences()
{
}

void Preferences::lpubPreferences()
{
  QDir cwd(QDir::currentPath());

  if (cwd.dirName() == "release" || cwd.dirName() == "debug") {
    cwd.cdUp();
  }
  lpubPath = cwd.absolutePath();
}

void Preferences::ldrawPreferences(bool force)
{
  QFileInfo fileInfo;
  QSettings settings(LPUB,SETTINGS);
  QString const ldrawKey("LDrawDir");
  
  if (settings.contains(ldrawKey)) {
    ldrawPath = settings.value(ldrawKey).toString();
  }

  if (ldrawPath != "" && ! force) {
    QDir cwd(ldrawPath);

    if (cwd.exists()) {
      return;
    }
  }

  ldrawPath = "c:/LDraw";

  QDir guesses;
  guesses.setPath(ldrawPath);
  if ( ! guesses.exists()) {
    ldrawPath = "c:/Program Files/LDraw";
    guesses.setPath(ldrawPath);
    if ( ! guesses.exists()) {

      ldrawPath = QFileDialog::getExistingDirectory(NULL,
                  QFileDialog::tr("Locate LDraw Directory"),
                  "/",
                  QFileDialog::ShowDirsOnly |
                  QFileDialog::DontResolveSymlinks);
    }
  }

  fileInfo.setFile(ldrawPath);

  if (fileInfo.exists()) {
    settings.setValue(ldrawKey,ldrawPath);
  } else {
    exit(-1);
  }  
}

void Preferences::lgeoPreferences()
{
	QSettings settings(LPUB,SETTINGS);
	bool lgeoInstalled;
	QString lgeoDirKey("LGEO");
	QString lgeoDir;
	if (settings.contains(lgeoDirKey)){
		lgeoDir = settings.value(lgeoDirKey).toString();
		QFileInfo info(lgeoDir);
		if (info.exists()) {
			lgeoInstalled = true;
			lgeoPath = lgeoDir;
		} else {
			settings.remove(lgeoDirKey);
			lgeoInstalled = false;
		}
	} else {
		lgeoInstalled = false;
	}
}

void Preferences::renderPreferences()
{
  QSettings settings(LPUB,SETTINGS);

  /* Find LDGLite's installation status */
  
  bool    ldgliteInstalled;
  QString const ldglitePathKey("LDGLite");
  QString ldglitePath;
  
  if (settings.contains(ldglitePathKey)) {
    ldglitePath = settings.value(ldglitePathKey).toString();
      QFileInfo info(ldglitePath);
    if (info.exists()) {
      ldgliteInstalled = true;
      ldgliteExe = ldglitePath;
    } else {
      settings.remove(ldglitePathKey);
      ldgliteInstalled = false;
    }
  } else {
    ldgliteInstalled = false;
  }
  
  /* Find LDView's installation status */
  
  bool    ldviewInstalled;
  QString const ldviewPathKey("LDView");
  QString ldviewPath;
  
  if (settings.contains(ldviewPathKey)) {
    ldviewPath = settings.value(ldviewPathKey).toString();
    QFileInfo info(ldviewPath);
    if (info.exists()) {
      ldviewInstalled = true;
      ldviewExe = ldviewPath;
    } else {
      settings.remove(ldviewPathKey);
      ldviewInstalled = false;
    }
  } else {
    ldviewInstalled = false;
  }
	
	/* Find L3P's installation status */
	
	bool    l3pInstalled;
	QString const l3pPathKey("L3P");
	QString const povrayPathKey("POVRAY");
	QString l3pPath, povrayPath;
	
	if (settings.contains(l3pPathKey)) {
		l3pPath = settings.value(l3pPathKey).toString();
		QFileInfo info(l3pPath);
		if (info.exists()) {
			l3pInstalled = true;
			l3pExe = l3pPath;
		} else {
			settings.remove(l3pPathKey);
			l3pInstalled = false;
		}
	} else {
		l3pInstalled = false;
	}
	
	
	
	if (settings.contains(povrayPathKey)) {
		povrayPath = settings.value(povrayPathKey).toString();
		QFileInfo info(povrayPath);
		if (info.exists()) {
			l3pInstalled &= true;
			povrayExe = povrayPath;
		} else {
			settings.remove(povrayPathKey);
			l3pInstalled &= false;
		}
	} else {
		l3pInstalled &= false;
	}

  /* Find out if we have a valid preferred renderer */
    
  QString const preferredRendererKey("PreferredRenderer"); 
  
  if (settings.contains(preferredRendererKey)) {
    preferredRenderer = settings.value(preferredRendererKey).toString();
    if (preferredRenderer == "LDGLite") {
      if ( ! ldgliteInstalled)  {
        preferredRenderer.clear();
          settings.remove(preferredRendererKey);    
      }
    } else if (preferredRenderer == "LDView") {
      if ( ! ldviewInstalled) {
        preferredRenderer.clear();
      settings.remove(preferredRendererKey);
      }
    } else if (preferredRenderer == "L3P") {
		if ( ! l3pInstalled) {
			preferredRenderer.clear();
			settings.remove(preferredRendererKey);
		}
    }
  }
  if (preferredRenderer == "") {
    if (ldviewInstalled && ldgliteInstalled) {
		preferredRenderer = l3pInstalled? "L3P" : "LDGLite";
    } else if (l3pInstalled) {
      preferredRenderer = "L3P";
    } else if (ldviewInstalled) {
		preferredRenderer = "LDView";
    } else if (ldgliteInstalled) {
      preferredRenderer = "LDGLite";
    }
  }
  if (preferredRenderer == "") {
    settings.remove(preferredRendererKey);
  } else {
    settings.setValue(preferredRendererKey,preferredRenderer);
  } 
}

void Preferences::pliPreferences()
{
  QSettings settings(LPUB,SETTINGS);
  pliFile = settings.value("PliControl").toString();
  
  QFileInfo fileInfo(pliFile);

  if (fileInfo.exists()) {
    return;
  } else {
    settings.remove("PliControl");
  }

  //QMessageBox::warning(NULL,"LPub",lpubPath,QMessageBox::Cancel);
  
#ifdef __APPLE__

  pliFile = lpubPath + "/pli.mpd";
  
#else
    
  pliFile = lpubPath + "/extras/pli.mpd";

#endif

  fileInfo.setFile(pliFile);
  if (fileInfo.exists()) {
    settings.setValue("PliControl",pliFile);
  } else {
    //pliFile = "";
  }
}

void Preferences::unitsPreferences()
{
  QSettings settings(LPUB,SETTINGS);
  if ( ! settings.contains("Centimeters")) {
    QVariant value(false);
    preferCentimeters = false;
    settings.setValue("Centimeters",value);
  } else {
    preferCentimeters = settings.value("Centimeters").toBool();
  }
}

void Preferences::fadestepPreferences()
{
  QSettings settings(LPUB,SETTINGS);
  if ( ! settings.contains("EnableFadeStep")) {
    QVariant value(false);
    enableFadeStep = false;
    settings.setValue("EnableFadeStep",value);
    fadeStepColor = "Very_Light_Bluish_Gray";
    settings.setValue("FadeStepColor",value);
  } else {
    enableFadeStep = settings.value("EnableFadeStep").toBool();
    fadeStepColor = settings.value("FadeStepColor").toString();
  }

}

bool Preferences::getPreferences()
{
  PreferencesDialog *dialog = new PreferencesDialog();
  
  QSettings settings(LPUB,SETTINGS);

  if (dialog->exec() == QDialog::Accepted) {
    if (ldrawPath != dialog->ldrawPath()) {
      ldrawPath = dialog->ldrawPath();
      if (ldrawPath == "") {
        settings.remove("LDrawDir");
      } else {
        settings.setValue("LDrawDir",ldrawPath);
      }
    }
	  
    if (pliFile != dialog->pliFile()) {
      pliFile = dialog->pliFile();
      if (pliFile == "") {
        settings.remove("PliControl");
      } else {
        settings.setValue("PliControl",pliFile);
      }
    }
	  if (l3pExe != dialog->l3pExe()) {
		  l3pExe = dialog->l3pExe();
		  if (l3pExe == "") {
			  settings.remove("L3P");
		  } else {
			  settings.setValue("L3P",l3pExe);
		  }
	  }
	  
	  
	  if (povrayExe != dialog->povrayExe()) {
		  povrayExe = dialog->povrayExe();
		  if (povrayExe == "") {
			  settings.remove("POVRAY");
		  } else {
			  settings.setValue("POVRAY",povrayExe);
		  }
	  }
	  
	  
	  if (lgeoPath != dialog->lgeoPath()) {
		  lgeoPath = dialog->lgeoPath();
		  if(lgeoPath == "") {
			  settings.remove("LGEO");
		  } else {
			  settings.setValue("LGEO",lgeoPath);
		  }
	  }
	  
    if (ldgliteExe != dialog->ldgliteExe()) {
      ldgliteExe = dialog->ldgliteExe();
      if (ldgliteExe == "") {
        settings.remove("LDGLite");
      } else {
        settings.setValue("LDGLite",ldgliteExe);
      }
    }
    if (ldviewExe != dialog->ldviewExe()) {
      ldviewExe = dialog->ldviewExe();
      if (ldviewExe == "") {
        settings.remove("LDView");
      } else {
        settings.setValue("LDView",ldviewExe);
      }
    }
      
    if (preferredRenderer != dialog->preferredRenderer()) {
      preferredRenderer = dialog->preferredRenderer();
      if (preferredRenderer == "") {
        settings.remove("PreferredRenderer");
      } else {
        settings.setValue("PreferredRenderer",preferredRenderer);
      }
    }
    preferCentimeters = dialog->centimeters();
    settings.setValue("Centimeters",preferCentimeters);
    defaultResolutionType(preferCentimeters);

    enableFadeStep = dialog->enableFadeStep();
    settings.setValue("EnableFadeStep", enableFadeStep);
    if (enableFadeStep && (fadeStepColor != dialog->fadeStepColor()))
    {
        fadeStepColor = dialog->fadeStepColor();
        if (fadeStepColor == "") {
            settings.remove("FadeStepColor");
        }else {
            settings.setValue("FadeStepColor", fadeStepColor);
        }
    }
    return true;
  } else {
    return false;
  }

}

void Preferences::getRequireds()
{
  if (preferredRenderer == "" && ! getPreferences()) {
    exit (-1);
  }
}



