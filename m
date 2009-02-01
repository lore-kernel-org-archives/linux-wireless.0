Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:52709 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbZBAEF2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jan 2009 23:05:28 -0500
Message-ID: <49851F73.4050204@openwrt.org> (sfid-20090201_050545_310530_E4989A7A)
Date: Sun, 01 Feb 2009 05:05:07 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: Bob Copeland <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	jirislaby@gmail.com, mcgrof@gmail.com
Subject: Re: [ath5k-devel] [PATCH 5/5] ath5k: Update reset code
References: <20090131023147.GE3342@makis>	 <20090131170802.GA16826@hash.localnet>	 <40f31dec0901311048t3834612cgc6b1dd01aa42a5c0@mail.gmail.com>	 <20090131223809.GA17413@hash.localnet> <40f31dec0901311950q27e28bb8we145c79488b1c7e1@mail.gmail.com>
In-Reply-To: <40f31dec0901311950q27e28bb8we145c79488b1c7e1@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nick Kossifidis wrote:
> 2009/2/1 Bob Copeland <me@bobcopeland.com>:
>> On Sat, Jan 31, 2009 at 08:48:02PM +0200, Nick Kossifidis wrote:
>>> > Heh, we should write a little tool to check the shifts and masks :)
>>> >
>>>
>>> Yup :P
>>
>> I just wrote one, I can post it later :)   It also found:
>>
>> AR5K_PHY_SIGMA_DELTA_ADC_CLIP 0x01ff3000 13
>>
>> Should be 12 or a different mask...
>>
> 
> 13 is correct
> 
> 0x01ff3000 -> 1111111111110000000000000
I think it's    1111111110011000000000000? :)

This mask makes 12 seem more likely.

- Felix
