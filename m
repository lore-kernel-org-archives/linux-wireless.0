Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41810 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155Ab0EDQTl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 12:19:41 -0400
Received: by fxm10 with SMTP id 10so3395283fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 May 2010 09:19:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1272986655.2486.42.camel@gnutoo-desktop>
References: <1272230300.2349.23.camel@gnutoo-desktop>
	 <1272232671.2349.25.camel@gnutoo-desktop>
	 <1272235632.2349.28.camel@gnutoo-desktop>
	 <1272285416.2364.1.camel@gnutoo-desktop>
	 <loom.20100427T143119-272@post.gmane.org>
	 <1272986655.2486.42.camel@gnutoo-desktop>
Date: Tue, 4 May 2010 19:19:39 +0300
Message-ID: <AANLkTikFu4yTnveOxj5Z3PWLgUD7FprMgG6qJXPWe4YE@mail.gmail.com>
Subject: Re: wl1251_sdio PSM
From: Grazvydas Ignotas <notasas@gmail.com>
To: gnutoo <GNUtoo@no-log.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 4, 2010 at 6:24 PM, gnutoo <GNUtoo@no-log.org> wrote:
>
>> You need a few more patches for PS to work (on top of current compat-wireless):
>> http://git.openpandora.org/cgi-bin/gitweb.cgi?p=pandora-kernel.git;a=commitdiff;h=8eb97a1915ae2ab0a19cc6eef1a2753b9514017d
>> http://git.openpandora.org/cgi-bin/gitweb.cgi?p=pandora-wifi.git;a=commitdiff;h=d16ed8871faa892f5fd4e8161412051ee11c5ecb
>>
>> I'm working on mainline mergeable versions of those..
> 2 things:
> *I rebased the patches against lastest compat wireless but I don't know
> where to send them...
> Basically or they apply or they are already in compat-wireless(verified)
> here are the one which applies:
> 0007-wl1251-read-default-MAC-address-from-EEPROM-when-ava.patch
> 0008-wl1251-register-platform_device-to-pass-board-data.patch
> 0009-wl1251-add-support-for-dedicated-IRQ-line.patch
> 0010-wl1251-use-sdio_readb_ext-for-ELP-to-work.patch
> 0011-wl1251-add-reset-handling.patch
> 0013-wl1251-prevent-scan-when-connected.patch
>
> against compat-wireless-2010-04-26

>From your list 0007-0009 are on their way to mainline, 0010-0013 are
not mainline friendly (0010 needs a new function in MMC subsystem
which I sent for review, 0011 depends on some code from Android tree,
0013 is a hack).

> By the way we can't make ad-hoc work,Is ad-hoc supported by the driver?

AFAIK it is not.


Grazvydas
