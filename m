Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:44666 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753334AbZCDPTE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2009 10:19:04 -0500
Message-ID: <49AE9BDD.7070603@lwfinger.net> (sfid-20090304_161907_672434_49A90D49)
Date: Wed, 04 Mar 2009 09:18:53 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Markus Feldmann <feldmann_markus@gmx.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: BCM4303 on HP zv5265ea
References: <gohr71$48f$1@ger.gmane.org> <49AC742D.9030309@lwfinger.net> <gom4ke$vle$1@ger.gmane.org>
In-Reply-To: <gom4ke$vle$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Markus Feldmann wrote:
> Larry Finger schrieb:
>>
>> This card works in most cases.
>>
>> What does the command 'dmesg | grep b43' show?
> Hi Larry,
> 
> nice to read you again. :-)
> 
> The needed modul for this card is <b43-legacy>.

Yes, I know that b43legacy is the right module for this device; however, the

dmesg | grep b43

will work for both b43leagacy and b43, which is why I use that form.

> I talked to you some time ago.
> The subject was <Do not get BCM4303 to work>.

I looked at that mail again. Have you figured out how to get your radio switch on?

> As i understood, only some of the developers for the
> <acpiphp> can solve this Problem, because the card
> will not be activated if this doesn't work.
> For example <M a t t h e w_G a r r e t> i think could solve this.
> 
> But he seems not to be online a long time.
> 
> So maybe the card could work, but only if i can activate
> it.
> 
> Do you know which Developer also works on this Modul ?

There are no developers that are working on b43legacy. Whenever a bug is found
in b43, I will propagate it to b43legacy, but that is the extent of development.

Unfortunately, none of us have a card with an RFKILL switch that uses b43legacy.
Without hardware in hand, debugging is too difficult. You will need to put
printk statements in your copy of the driver to find out where it fails.

Larry

