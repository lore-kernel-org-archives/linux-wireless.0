Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55141 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab2IGIoS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 04:44:18 -0400
Received: by eaac11 with SMTP id c11so819696eaa.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Sep 2012 01:44:17 -0700 (PDT)
Date: Fri, 7 Sep 2012 10:44:10 +0200
From: Anisse Astier <anisse@astier.eu>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	=?UTF-8?B?5p2O5pyd?= =?UTF-8?B?5piO?=
	<chaoming_li@realsil.com.cn>
Subject: Re: rtl8192ce: activation problem with rtl8188ce pci card
Message-ID: <20120907104410.62e43ca6@destiny.ordissimo> (sfid-20120907_104424_980817_EA99F20C)
In-Reply-To: <5048F3D8.9030509@lwfinger.net>
References: <20120905185510.2ab501cd@destiny.ordissimo>
	<50478E10.6030808@lwfinger.net>
	<20120905201437.70c008ca@destiny.ordissimo>
	<5047B508.5030606@lwfinger.net>
	<20120906161529.016b2202@destiny.ordissimo>
	<5048D138.1080109@lwfinger.net>
	<20120906202710.30c4bc8a@destiny.ordissimo>
	<5048F3D8.9030509@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 06 Sep 2012 14:04:56 -0500, Larry Finger <Larry.Finger@lwfinger.net> wrote :

> Perhaps Chaoming knows something about this output. All I know is that you now 
> have the latest driver.
> 
> If you apply the attached patch, it will log the firmware name. That will tell 
> us what cut you have. If you have quilt installed, you can "quilt import 
> filename" and "quilt push", otherwise just use the patch utility. I checked and 
> the version of the firmware files in this driver match those in the 
> linux-firmware git repo.

firmware is rtlwifi/rtl8192cfwU_B.bin (UMC B CUT)

> 
>  From your name and E-mail address, I would guess you are in France. If you were 
Indeed.

> in the US, I would send you one of my standard cards in exchange for yours so 
> that I could sort out the driver for it. Perhaps that would still work.

I can send you a card. Please contact me in private. There's also no
guarantee that it freezes on your laptops.

Regarding your previous thought of it being an SMP/locking related issue:
I tried disabling the second core in the BIOS (/proc/cpuinfo only shows
one CPU) : no change.

Anisse
