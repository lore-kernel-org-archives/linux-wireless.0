Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:60091 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbaGIRrO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2014 13:47:14 -0400
Received: by mail-we0-f177.google.com with SMTP id u56so7815287wes.22
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2014 10:47:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <21437.22159.76409.186487@gargle.gargle.HOWL>
References: <1404725506-9571-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1404725506-9571-4-git-send-email-lorenzo.bianconi83@gmail.com>
	<21437.22159.76409.186487@gargle.gargle.HOWL>
Date: Wed, 9 Jul 2014 19:47:13 +0200
Message-ID: <CAA2SeNJBXdi8vPa2qe4oHZK=OZ+pbBTd_pmDmyTpCeE21isQ2g@mail.gmail.com> (sfid-20140709_194718_556227_D6777B98)
Subject: Re: [RFC 03/10] ath9k: add dynamic ack timeout estimation
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: ath9k-devel <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sujith,

> Lorenzo Bianconi wrote:
>> +/*
>> + * Copyright 2014, Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>
> I have not reviewed the patches, but the ath9k driver is licensed
> under ISC. Introducing a file with GPLv2 license is bound to cause
> complications and I think might require legal clearance from a
> QCA employee maintaining ath9k.
>
> Right now, I am not sure if there is an official maintainer for
> ath9k, but is there any specific reason why you have chosen
> GPLv2 ?
>
> Sujith

Nope. I didn't know ath9k is under ISC license. I think I can replace
GPLv2 license with an ISC one.
Best regards,

Lorenzo


-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
