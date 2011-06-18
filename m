Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59929 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab1FRJlE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 05:41:04 -0400
Received: by yxi11 with SMTP id 11so1590584yxi.19
        for <linux-wireless@vger.kernel.org>; Sat, 18 Jun 2011 02:41:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201106141612.11117.chunkeey@googlemail.com>
References: <BANLkTim0mV230taAmbTm_Rm0wfPBGAznhw@mail.gmail.com>
	<201106141612.11117.chunkeey@googlemail.com>
Date: Sat, 18 Jun 2011 11:41:02 +0200
Message-ID: <BANLkTi=6=KHkPLeZawhoK3=9Ysk2C-PQHA@mail.gmail.com> (sfid-20110618_114116_249014_22DA4AE9)
Subject: Re: DWA-160
From: Thomas Novin <thomas@xyz.pp.se>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: ShawnG <swggator4@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 14, 2011 at 4:12 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Tuesday 14 June 2011 15:45:28 ShawnG wrote:
>> I have been seeing strange stuff with the DWA-160 ver A2. Can you recommend
>> another USB Wifi stick to replace ?
> Depends. I've to say that I'm slightly biased towards Atheros products.
> Although, Ralink and Realtek have interesting products as well.
>
> So, if you don't need 5GHz then I would go with a ath9k_htc device
> like: TL-WN821N *V3* [Note: V3 is important, because previous
> versions are based on AR9170, however they stopped making them
> some time ago [6-7 months?], so it should be safe to assume they've
> disappeared from retail stores by now.]
>
> if you do need 5GHz, then it might be a good idea to ask:
> George Nychis <gnychis@cmu.edu>
>
> He has done some testing with several 5GHz capable ath9k_htc devices
> from different vendors and might know which are well suited.

I asked Geoprge Nychis and got a reply.

He recommends http://www.wikidevi.com/wiki/Sony_UWA-BR100 which has
AR7010 + AR9280 chipset. Almost the same as  TL-WN821N v3 but
secondary chip is a little different as the TP-Link has AR9287.

Found them on Amazon for $75. I don't know if these works
out-of-the-box or that maybe you have to edit the source a little bit
to get the IDs supported? Well doesn't really matter for me, easy to
fix.

Rgds//Thomas
