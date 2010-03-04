Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49176 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754347Ab0CDI5c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 03:57:32 -0500
From: Malte Gell <malte.gell@gmx.de>
To: linux-wireless@vger.kernel.org
Subject: Re: Kernel 2.6.33: ar9170.fw firmware file not found
Date: Thu, 4 Mar 2010 09:57:26 +0100
References: <201003040835.29387.malte.gell@gmx.de>
In-Reply-To: <201003040835.29387.malte.gell@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201003040957.27052.malte.gell@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Malte Gell <malte.gell@gmx.de> wrote

> I just upgraded from Kernel 2.6.32 to 2.6.33 and the ar9170 driver suddenly
> says "firmware file not found". Of course, I have the one stage and the two
>  two stage files in /lib/firmware. What does this error occur? Do I have to
>  update the firmware? Does kernel 2.6.33 need more recent firmware files?
>  Or what is the reason? Or is it a bug?

I have added the rule

SUBSYSTEM=="compat_firmware", ACTION=="add", RUN+="firmware.sh"

to /lib/udev/rules.d/50-udev-default.rules (openSUSE 11.1), but it did not 
help yet... it still got not found...
