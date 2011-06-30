Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:46816 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396Ab1F3Sqc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 14:46:32 -0400
Received: by wwg11 with SMTP id 11so1152437wwg.5
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2011 11:46:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E0A1B4F.8080700@boundarydevices.com>
References: <4E0942CA.9010402@boundarydevices.com> <BANLkTikp+58Ae14a1OXr0F_OSsip69++yQ@mail.gmail.com>
 <4E0A1B4F.8080700@boundarydevices.com>
From: "Krakowski, Oz" <ozk@ti.com>
Date: Thu, 30 Jun 2011 13:46:10 -0500
Message-ID: <BANLkTi=2DzzXmwJeY-SmiKz24m1KsyW29Q@mail.gmail.com> (sfid-20110630_204635_890637_3CA34862)
Subject: Re: WL1271: WLAN_IRQ not working
To: Troy Kisky <troy.kisky@boundarydevices.com>
Cc: "Levi, Shahar" <shahar_levi@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Troy,

On Tue, Jun 28, 2011 at 1:19 PM, Troy Kisky
<troy.kisky@boundarydevices.com> wrote:
<snip>
> Thanks for taking a look. I'm pretty sure it is a hardware problem and
> not software. proc/interrupts is showing the correct irq as claimed.
> Looking at a scope, I'm just getting no activity on the WLAN_IRQ pin.

Can you tell us what is the host configuration on the host pin? In
other words, what type of detection - edge or level. Also, what is the
pull configuration - up or down, and how much pull.
The pull up/down configuration, if not correctly set, could explain
why you don't see anything in the scope.

> The datasheet says that the slow clock is 32768 HZ +/- 150 ppm. Mine
> currently measures 32650. This needs fixed, but is unlikely to be my
> problem isn't it?

See if you can get closer to the required value, but I don't think it
is the problem here either.

Regards,
Oz.
