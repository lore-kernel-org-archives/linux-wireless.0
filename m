Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:60103 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350Ab3BRTOk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 14:14:40 -0500
Received: by mail-wg0-f43.google.com with SMTP id e12so4957888wge.22
        for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2013 11:14:39 -0800 (PST)
Message-ID: <51227D9C.3090106@gmail.com> (sfid-20130218_201449_437204_134AD747)
Date: Mon, 18 Feb 2013 20:14:36 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: m.vietri@sns.it, linux-wireless <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: Linksys AE3000
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mario Vietri wrote:

> I run an up-to-date ArchLinux system on a Toshiba Portege 
> R600. I own a Linksys AE3000 (0x13b1:0x003b) usb wifi adapter, 
> with driver downloaded from WikiDevi as per their AE3000 page, 
> with the usual modifications.

Linksys AE3000 brings a RT3593 chip.
And still there is no support for any Ralink/Mediatek 3T3R chip
(RF3053/RF3853)/(RT3883/RT3563/RT3573/RT3593/RT3662)
in the rt2800{usb,pci} kernel drivers.

The only think you can do is try latest driver from mediatek:
http://www.mediatek.com/_en/07_downloads/01_windows.php?sn=501
(unsupported by linux-wireless/rt2x00 mailing lists)
