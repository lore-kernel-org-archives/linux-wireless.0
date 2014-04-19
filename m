Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:41468 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbaDSLtp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Apr 2014 07:49:45 -0400
Message-ID: <53526124.6050407@msgid.tls.msk.ru> (sfid-20140419_134949_236165_50C1E741)
Date: Sat, 19 Apr 2014 15:42:28 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org
Subject: Re: BCM4313 & brcmsmac & 3.12: only semi-working?
References: <52BDE9DC.5040206@msgid.tls.msk.ru> <52BE9CF9.7030305@broadcom.com> <52BEC2F6.7010505@msgid.tls.msk.ru> <52D4FC8B.6090301@msgid.tls.msk.ru> <52F925A9.1030707@msgid.tls.msk.ru>
In-Reply-To: <52F925A9.1030707@msgid.tls.msk.ru>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

10.02.2014 23:16, Michael Tokarev wrote:
[big skip]


Tried kernel 3.14 with this device.  Still no go, the brcmsmac driver still
does not work correctly, it stalls as before.

On the other hand, I found out how to compile the proprietary driver for
3.10+ kernels, it requires some rather minor source modifications.

/mjt
