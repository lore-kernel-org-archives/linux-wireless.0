Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dub004-omc3s15.hotmail.com ([157.55.2.24]:54442 "EHLO
	DUB004-OMC3S15.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756876AbbGGLY2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2015 07:24:28 -0400
Message-ID: <DUB128-W333766FA47F8690AEA26469C920@phx.gbl> (sfid-20150707_132445_324038_15807305)
From: David Binderman <dcb314@hotmail.com>
To: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	"dean.lee@atmel.com" <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: linux-4.2-rc1/drivers/staging/wilc1000/linux_wlan.c:1874: bad test ?
Date: Tue, 7 Jul 2015 11:19:23 +0000
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello there,

[linux-4.2-rc1/drivers/staging/wilc1000/linux_wlan.c:1874]: (style) A pointer can not be negative so it is either pointless or an error to check if it is.

Source code is

     if (wilc_mac_thread < 0) {

but

struct task_struct *wilc_mac_thread;

Regards

David Binderman

 		 	   		  