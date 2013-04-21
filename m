Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33053 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3DUXXB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Apr 2013 19:23:01 -0400
Received: by mail-wi0-f174.google.com with SMTP id m6so3395025wiv.1
        for <linux-wireless@vger.kernel.org>; Sun, 21 Apr 2013 16:23:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20130421T145410-125@post.gmane.org>
References: <87li8k0yu1.fsf@kamboji.qca.qualcomm.com> <20130415204030.51f20f43@m4a785t-m.gnutoo.workgroup>
 <loom.20130421T145410-125@post.gmane.org>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 22 Apr 2013 09:22:40 +1000
Message-ID: <CAGRGNgVUNP-qp-1kNmy6_OrZLi5CuR2GShxt-M7idxVKmMhKMw@mail.gmail.com> (sfid-20130422_012324_499619_05F320BF)
Subject: Re: ath10k: mac80211 driver for QCA9880
To: Edward <eliasacorn@yahoo.com.sg>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Edward,

On Sun, Apr 21, 2013 at 10:59 PM, Edward <eliasacorn@yahoo.com.sg> wrote:
> Denis 'GNUtoo' Carikli <GNUtoo@...> writes:
>> On Mon, 15 Apr 2013 15:20:54 +0300
>> Kalle Valo <kvalo@...> wrote:
>> >The biggest difference is that there's now firmware running on the
>> >chip.
>> Will the firmware be released as free software at some point?
>
> Does it matter? The firmware is just a binary logic black box. It's not
> likely to even see more than a handful of revisions after the actual
> products hit the market.

I believe the question was asked as Atheros / Qualcomm has a history
of releasing firmware for their devices, i.e. the ar9170 and ar7010 /
ar9271 chips, I believe Denis was wondering if this practise would
continue.

> As long as the driver remains open I don't see any problems with the
> open-driver-closed-firmware combination. Intel and Ralink has adopted this
> practice to great success, and I don't see any reason why Atheros can't do
> the same.

I don't believe anyone has problems with things being done this way,
we'd just like to know if there's a release scheduled.

Thanks,

--
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
