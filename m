Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f21.google.com ([209.85.217.21]:57000 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbZAaW6P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jan 2009 17:58:15 -0500
Received: by gxk14 with SMTP id 14so811391gxk.13
        for <linux-wireless@vger.kernel.org>; Sat, 31 Jan 2009 14:58:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090131223809.GA17413@hash.localnet>
References: <20090131023147.GE3342@makis>
	 <20090131170802.GA16826@hash.localnet>
	 <40f31dec0901311048t3834612cgc6b1dd01aa42a5c0@mail.gmail.com>
	 <20090131223809.GA17413@hash.localnet>
Date: Sun, 1 Feb 2009 00:58:14 +0200
Message-ID: <40f31dec0901311458m29acaaect3f86586756c88f4c@mail.gmail.com> (sfid-20090131_235823_930868_132475A7)
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

ACK

>> Thanks a lot for your comments, i'll address them asap and come up
>> with a new version of this patch ;-)
>
> My computer also hangs with the whole series... reverting the reset
> part makes it work.  I'll try and narrow that down later when I
> get some time.
>

O.K. i'll work on the other issues and when you find the problem let
me know so i can resend reset patch.

Are you all ok on the rest 4 patches ?



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
