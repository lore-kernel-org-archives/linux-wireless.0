Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33384 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab0JVWbV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 18:31:21 -0400
Received: by yxn35 with SMTP id 35so1083401yxn.19
        for <linux-wireless@vger.kernel.org>; Fri, 22 Oct 2010 15:31:20 -0700 (PDT)
Message-ID: <4CC210C3.7010602@lwfinger.net>
Date: Fri, 22 Oct 2010 17:31:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH] b43: rfkill: use status register based on core revision
 not (PHY's)
References: <1287779045-20257-1-git-send-email-zajec5@gmail.com>	<4CC2043D.2040909@lwfinger.net> <AANLkTika4wVhH=rGc=qgZozgbe9j-+-zzPkb1KGWLHJC@mail.gmail.com>
In-Reply-To: <AANLkTika4wVhH=rGc=qgZozgbe9j-+-zzPkb1KGWLHJC@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/22/2010 04:57 PM, Rafał Miłecki wrote:
> W dniu 22 października 2010 23:38 użytkownik Larry Finger
> <Larry.Finger@lwfinger.net> napisał:
>> On 10/22/2010 03:24 PM, Rafał Miłecki wrote:
>>
>> As that register is present only when the core revision >= 3, this change should
>> not cause a regression. Perhaps this was an error in the RE from the start and
>> testing the phy.rev has always been wrong.
> 
> Do not blame RE team ;) It was described correctly since "ever", you
> can check it in history of:
> http://bcm-specs.sipsolutions.net/MMIO
> 
> I actually suspect this may be source of self-switching-on-off-radio
> issue described in:
> "b43legacy-phy3: Radio hardware status changed to XXX" thread.
> 
> I already mailed reporter to ask if he still has access to problematic card.

I have two cards that use b43legacy, but their physical format (PCI and Cardbus)
do not include an RFKILL switch, thus I have never tested this code with b43legacy.

Larry



