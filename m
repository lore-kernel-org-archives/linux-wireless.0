Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab3K3TL0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Nov 2013 14:11:26 -0500
Message-ID: <1385838681.2566.6.camel@adam.happyassassin.net> (sfid-20131130_201129_337869_592CD0D8)
Subject: Support for Atheros chipset with SDIO ID 0271:0418 ?
From: Adam Williamson <awilliam@redhat.com>
To: linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com
Date: Sat, 30 Nov 2013 11:11:21 -0800
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, folks - I hope this is the appropriate place, it's as close as I
could manage to Google myself :) I recently bought a Dell Venue 8 Pro -
a Bay Trail / Valley View-based Intel tablet - to try and get Fedora
running on it. Among the many things I'm currently fighting :), the
wireless doesn't work - no driver is loaded, no interface appears at
all. Using the Device Manager in Windows 8 I've managed to identify it
as being attached via SDIO and having the device ID 0271:0418 . It calls
itself a "Dell Wireless 1538", but by the ID and various other details
about the Windows driver it's clearly a Qualcomm/Atheros part.

So the ath6kl-sdio driver in the kernel advertises support for:

alias:          sdio:c*v0271d0401*
alias:          sdio:c*v0271d0400*
alias:          sdio:c*v0271d0301*
alias:          sdio:c*v0271d0300*

Looks pretty close, but no cigar. I'm having trouble finding any more
information on the chipset than what I've outlined above. It seems most
likely that it's a variant of the AR6004 for Dell, but that's just my
best guess.

Is there any hope of getting support for this device in ath6kl or any
other driver? Thanks!
-- 
Adam Williamson
Fedora QA Community Monkey
IRC: adamw | Twitter: AdamW_Fedora | XMPP: adamw AT happyassassin . net
http://www.happyassassin.net

