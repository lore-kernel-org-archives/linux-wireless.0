Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48070 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab0BOPKN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 10:10:13 -0500
Date: Mon, 15 Feb 2010 09:10:08 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Bernhard Schiffner <bernhard@schiffner-limbach.de>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 0/3 V2] staging: r8187se: Miscellaneous cleanups
Message-ID: <4b7963d0.cocDj1pGMQ3LKF4a%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series of patches comprise further cleanups of the staging driver.

1. Remove dead routine from r8180_core.c.

2. Remove two private variables that have a fixed value.

3. Remove dead code from r8185b_init.c.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Patch 1:

 r8180_core.c |   37 -------------------------------------
 1 file changed, 37 deletions(-)

Patch 2:

 r8180.h           |    4
 r8180_core.c      |   90 -------------
 r8180_dm.c        |   71 ++--------
 r8180_rtl8225z2.c |  238 +++++++++++++++-------------------
 r8185b_init.c     |  368 +++++++++++-------------------------------------------
 5 files changed, 197 insertions(+), 574 deletions(-)

Patch 3:

 r8185b_init.c |  633 ----------------------------------------------------------
 1 file changed, 2 insertions(+), 631 deletions(-)


