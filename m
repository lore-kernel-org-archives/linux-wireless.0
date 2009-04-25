Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:58123 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbZDYQKD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Apr 2009 12:10:03 -0400
From: Christian Lamparter <chunkeey@web.de>
To: eric.valette@free.fr
Subject: Re: Problem loading ar9170 on an atheros dongle
Date: Sat, 25 Apr 2009 18:10:00 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <49F2C543.8030703@free.fr> <200904251644.16465.chunkeey@web.de> <49F32FC8.7040403@free.fr>
In-Reply-To: <49F32FC8.7040403@free.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <200904251810.00269.chunkeey@web.de> (sfid-20090425_181008_835912_FC9E331A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 25 April 2009 17:44:08 Eric Valette wrote:
> Christian Lamparter wrote:
> > On Saturday 25 April 2009 10:09:39 Eric Valette wrote:
> >> Hi,
> >>
> >> I've a dongle thta is marked as supported but I cannot get the driver to
> >> load correctly.
> >>
> >> Attached the trace at the end of dmesg. I can try patches add traces, ...
> >>
> >> Thanks for the work on this chipset.
> >>
> > check if your firmware md5sum matches those on our wiki site
> > (see kconfig for link)
> 
> No. But down loading again does not change anything.
what a surprise ;)

> Any ftp location rather than via git?
I don't know of any ftp/http mirror, so you want to use git.

git clone git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git

will get the whole tree and don't worry it is not that big yet...

Regards,
	Chr
