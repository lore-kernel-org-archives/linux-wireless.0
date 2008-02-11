Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:42951 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239AbYBKOVE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2008 09:21:04 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Eddy =?utf-8?q?Petri=C8=99or?= <eddy.petrisor@gmail.com>
Subject: Re: weird issues with b43 - and an oops
Date: Mon, 11 Feb 2008 15:20:35 +0100
Cc: linux-wireless@vger.kernel.org
References: <47B02CBB.1060406@gmail.com>
In-Reply-To: <47B02CBB.1060406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200802111520.36105.mb@bu3sch.de> (sfid-20080211_142138_065457_3FEA4775)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 11 February 2008 12:08:43 Eddy Petri=C8=99or wrote:
> Feb 11 03:32:12 bounty kernel: b43-phy0 ERROR: Microcode not respondi=
ng
> Feb 11 03:32:12 bounty kernel: b43-phy0 ERROR: You must go to=20
> http://linuxwireless.org/en/users/Drivers/b43#devicefirmware and=20
> download the correct firmware (version 4).

Do this.

> Feb 11 03:32:12 bounty dhclient: wmaster0: unknown hardware address t=
ype 801
> Feb 11 03:32:12 bounty kernel: input: b43-phy0 as /class/input/input1=
7
> Feb 11 03:32:12 bounty kernel: WARNING: at drivers/ssb/main.c:883=20
> ssb_tmslow_reject_bitmask()

And use the b43 driver from wireless-2.6


--=20
Greetings Michael.
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
