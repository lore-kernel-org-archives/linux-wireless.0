Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:59919 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932157Ab0JUNuF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Oct 2010 09:50:05 -0400
Message-ID: <4CC04F55.1020803@gmx.net>
Date: Thu, 21 Oct 2010 16:33:57 +0200
From: George <george.news@gmx.net>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: usb_enable_autosuspend not supported in 2.6.32
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Compiling last compat-wireless 2010-10-20 on ubuntu 10.04 updated I got

btusb.c: In function 'bt_probe':
error: implicit declaration of function 'usb_enable_autosuspend'

as it is not declared in include/linux/usb.h headers it has to be, 
probably in compat-2.6.X.

Just to point that out.

See you
Jorge
