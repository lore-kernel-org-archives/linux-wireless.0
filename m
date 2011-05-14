Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53431 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758193Ab1ENPz5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 May 2011 11:55:57 -0400
Message-ID: <4DCEA60A.5010600@candelatech.com> (sfid-20110514_175600_913591_01F43DB9)
Date: Sat, 14 May 2011 08:55:54 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Can't get hostapd to start, channels are all passive-scanning?
References: <4DCDC068.9060307@candelatech.com>	<4DCDC7A0.2020504@candelatech.com> <BANLkTikv9jhZaC=+Rtn5DmHADEJkvqo3KQ@mail.gmail.com>
In-Reply-To: <BANLkTikv9jhZaC=+Rtn5DmHADEJkvqo3KQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/13/2011 08:41 PM, Adrian Chadd wrote:
> What's the regulatory domain of the NIC?

 From the boot where it worked:

ath: EEPROM regdomain: 0x0
ath: EEPROM indicates default country code should be used
ath: doing EEPROM country->regdmn map search
ath: country maps to regdmn code: 0x3a
ath: Country alpha2 being used: US
ath: Regpair used: 0x3a

Seems this isn't saved in /var/log/messages, so no idea what it was on the
previous boot where things were more weird than normal.

> Is it some strange race condition with CRDA?

Hard to say.  I did check the 'iw reg get' and it looked
sane..but maybe that wouldn't show the problem...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
