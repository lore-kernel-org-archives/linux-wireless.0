Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:35398 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbbFMGl3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jun 2015 02:41:29 -0400
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/2] staging: wilc1000: remove itypes.h
Date: Sat, 13 Jun 2015 15:41:19 +0900
Message-Id: <1434177679-9831-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20150613_084134_813702_06EDE951)
In-Reply-To: <1434177679-9831-1-git-send-email-chaehyun.lim@gmail.com>
References: <1434177679-9831-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove itypes.h that is not needed.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c |  1 -
 drivers/staging/wilc1000/host_interface.c   |  1 -
 drivers/staging/wilc1000/itypes.h           | 39 -----------------------------
 3 files changed, 41 deletions(-)
 delete mode 100644 drivers/staging/wilc1000/itypes.h

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 9abc73d..792ba6d 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -12,7 +12,6 @@
 /*****************************************************************************/
 /* File Includes                                                             */
 /*****************************************************************************/
-#include "itypes.h"
 #include "coreconfigurator.h"
 /*****************************************************************************/
 /* Constants                                                                 */
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ca59f1b..1e9a2f1 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1,6 +1,5 @@
 #include "host_interface.h"
 #include "wilc_oswrapper.h"
-#include "itypes.h"
 #include "coreconfigurator.h"
 
 extern s32 TransportInit(void);
diff --git a/drivers/staging/wilc1000/itypes.h b/drivers/staging/wilc1000/itypes.h
deleted file mode 100644
index d64ae35..0000000
--- a/drivers/staging/wilc1000/itypes.h
+++ /dev/null
@@ -1,39 +0,0 @@
-/*****************************************************************************/
-/*                                                                           */
-/*                     Ittiam 802.11 MAC SOFTWARE                            */
-/*                                                                           */
-/*                  ITTIAM SYSTEMS PVT LTD, BANGALORE                        */
-/*                           COPYRIGHT(C) 2005                               */
-/*                                                                           */
-/*  This program  is  proprietary to  Ittiam  Systems  Private  Limited  and */
-/*  is protected under Indian  Copyright Law as an unpublished work. Its use */
-/*  and  disclosure  is  limited by  the terms  and  conditions of a license */
-/*  agreement. It may not be copied or otherwise  reproduced or disclosed to */
-/*  persons outside the licensee's organization except in accordance with the*/
-/*  terms  and  conditions   of  such  an  agreement.  All  copies  and      */
-/*  reproductions shall be the property of Ittiam Systems Private Limited and*/
-/*  must bear this notice in its entirety.                                   */
-/*                                                                           */
-/*****************************************************************************/
-
-/*****************************************************************************/
-/*                                                                           */
-/*  File Name         : itypes.h                                             */
-/*                                                                           */
-/*  Description       : This file contains all the data type definitions for */
-/*                      MAC implementation.                                  */
-/*                                                                           */
-/*  List of Functions : None                                                 */
-/*  Issues / Problems : None                                                 */
-/*                                                                           */
-/*  Revision History  :                                                      */
-/*                                                                           */
-/*         DD MM YYYY   Author(s)       Changes                              */
-/*         01 05 2005   Ittiam          Draft                                */
-/*                                                                           */
-/*****************************************************************************/
-
-#ifndef ITYPES_H
-#define ITYPES_H
-
-#endif /* ITYPES_H */
-- 
1.9.1

