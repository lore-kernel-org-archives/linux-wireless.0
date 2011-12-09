Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:46149 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab1LISpe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Dec 2011 13:45:34 -0500
Date: Fri, 9 Dec 2011 19:45:24 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: RFKILL switch operations with b43
Message-ID: <20111209194524.7f57f936@milhouse> (sfid-20111209_194537_142265_B5E0F60C)
In-Reply-To: <4EE25315.9030504@lwfinger.net>
References: <4EE25315.9030504@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 09 Dec 2011 12:27:33 -0600
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> Does anyone have a laptop with a slide switch (definite on/off positions) and is 
> using b43? If so, are the "ENABLED" and "DISABLED" messages logged when you move 
> the switches? What kernel are you using?
> 
> The mini-PCIe slot in my laptop is broken, and I need to use an extender, thus I 
> cannot do the test myself.

If you're not too fat fingered, you can probably modify your extender to add a switch
or jumper (or loose wire ;) that pulls pin20 to GND with a resistor or floats it.
That should emulate the rfkill input signal to the wireless device.

http://pinoutsguide.com/Slots/mini_pcie_pinout.shtml

-- 
Greetings, Michael.
