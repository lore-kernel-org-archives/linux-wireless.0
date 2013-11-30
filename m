Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55582 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751913Ab3K3OV7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Nov 2013 09:21:59 -0500
Message-Id: <1385821318.11810.53811117.0E0E19AF@webmail.messagingengine.com> (sfid-20131130_152202_418067_1F6B3285)
From: "Nikita N." <nikitan@operamail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>, backports@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: 3.13 various backports bugs
Date: Sat, 30 Nov 2013 06:21:58 -0800
In-Reply-To: <5299E184.1020302@hauke-m.de>
References: <1385815530.23776.53787977.56B183FC@webmail.messagingengine.com>
 <5299E184.1020302@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

follow answers
On Sat, Nov 30, 2013, at 05:00 AM, Hauke Mehrtens wrote:
> > - Bug #2:
> > eeprom modules are missing into 3.13.
> > This issue is present systematically in all backports releases, since
> > the switch from compat-drivers.
> > It could be a wireless bug only, or a backports bug only, or both.
> > Anyway, eeprom module is vital for correct interface detection.
> > Into 3.9 the eeprom modules are located in
> > ./compat-drivers-3.9-rc4-2-su/drivers/misc/eeprom/
> 
> This should be included in your kernel you are compiling against
> otherwise you wouldn't be able to build rtl8187.
> 
> There was a bug in backports regarding EEPROM_93CX6, could you please
> try backports-20131122-2 and report back if the problem is still there.

just did it, same issue.
also in backports-20131122-2 eeprom modules are missing.
At this point I have the suspect that eeprom libraries builtin Slitaz4
are bugged, and the bug is capable of persistent damage.. probably the
bad frames filter in monitor mode im suffering on my two rtl8187, is
caused by that..? 
If that would be confirmed, Slitaz4 community has to be warned asap!
If I can help more, please fell free to ask :)

-- 
http://www.fastmail.fm - Accessible with your email software
                          or over the web

