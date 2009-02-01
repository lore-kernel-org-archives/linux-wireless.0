Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.185]:3618 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbZBADum (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jan 2009 22:50:42 -0500
Received: by rn-out-0910.google.com with SMTP id k40so729615rnd.17
        for <linux-wireless@vger.kernel.org>; Sat, 31 Jan 2009 19:50:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090131223809.GA17413@hash.localnet>
References: <20090131023147.GE3342@makis>
	 <20090131170802.GA16826@hash.localnet>
	 <40f31dec0901311048t3834612cgc6b1dd01aa42a5c0@mail.gmail.com>
	 <20090131223809.GA17413@hash.localnet>
Date: Sun, 1 Feb 2009 05:50:41 +0200
Message-ID: <40f31dec0901311950q27e28bb8we145c79488b1c7e1@mail.gmail.com> (sfid-20090201_045100_050601_15A1845F)
Subject: Re: [ath5k-devel] [PATCH 5/5] ath5k: Update reset code
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/2/1 Bob Copeland <me@bobcopeland.com>:
> On Sat, Jan 31, 2009 at 08:48:02PM +0200, Nick Kossifidis wrote:
>> > Heh, we should write a little tool to check the shifts and masks :)
>> >
>>
>> Yup :P
>
> I just wrote one, I can post it later :)   It also found:
>
> AR5K_PHY_SIGMA_DELTA_ADC_CLIP 0x01ff3000 13
>
> Should be 12 or a different mask...
>

13 is correct

0x01ff3000 -> 1111111111110000000000000

12 only counts the 3 zeros (3 * 4)

I've fixed all things mentioned so far, as soon as you find out why it
hangs on your pc we can move on ;-)

Again thanks a lot for the review ;-)

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
