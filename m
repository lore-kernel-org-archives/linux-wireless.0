Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.184]:46301 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758116AbYILUpS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 16:45:18 -0400
Received: by rn-out-0910.google.com with SMTP id k40so775365rnd.17
        for <linux-wireless@vger.kernel.org>; Fri, 12 Sep 2008 13:45:16 -0700 (PDT)
Message-ID: <43e72e890809121345o57fe769bhcb90c398d7672682@mail.gmail.com> (sfid-20080912_224525_511105_9220486A)
Date: Fri, 12 Sep 2008 13:45:16 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Davide Pesavento" <davidepesa@gmail.com>
Subject: Re: ath9k: unable to reset hardware
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <2da21fe50809121338s26106a07iddaa54faf3c68ada@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <2da21fe50809121338s26106a07iddaa54faf3c68ada@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 12, 2008 at 1:38 PM, Davide Pesavento <davidepesa@gmail.com> wrote:
> Hi!
>
> [ 4342.364205] ath_open: unable to reset hardware; hal status
> 4294967277 (freq 2437 flags 0x700e2)
> [ 4342.364957] ath9k_start: Unable to complete ath_open
> [ 4372.412478] ath_open: unable to reset hardware; hal status
> 4294967277 (freq 2437 flags 0x700e2)
> [ 4372.420685] ath9k_start: Unable to complete ath_open
> [ 4373.101414] ath_open: unable to reset hardware; hal status
> 4294967277 (freq 2437 flags 0x700e2)
> [ 4373.102549] ath9k_start: Unable to complete ath_open
>
> I'm using 2.6.27-rc5-wl-16606-g643e533 on a MacBookPro2,2 (AR5418).
> rmmod ath9k && modprobe ath9k is enough to fix the issue, but
> connectivity becomes a lot more unstable after that.

Thanks for the report, we will look into this.

  Luis
