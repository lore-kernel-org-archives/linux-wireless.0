Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58664 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751327AbcJ0GCM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Oct 2016 02:02:12 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Antonio Quartulli <a@unstable.cc>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
        sw@simonwunderlich.de, Antonio Quartulli <antonio@open-mesh.com>
Subject: Re: [NOT FOR MERGE] ath9k: work around key cache corruption
References: <20161018083552.28592-1-a@unstable.cc>
        <87lgxbxl2d.fsf@purkki.adurom.net>
        <20161026141016.GB26376@prodigo.lan>
Date: Thu, 27 Oct 2016 09:02:03 +0300
In-Reply-To: <20161026141016.GB26376@prodigo.lan> (Antonio Quartulli's message
        of "Wed, 26 Oct 2016 22:10:16 +0800")
Message-ID: <87bmy65nz8.fsf@kamboji.qca.qualcomm.com> (sfid-20161027_080217_992215_1C5CA69C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Antonio Quartulli <a@unstable.cc> writes:

> On Wed, Oct 26, 2016 at 05:05:14PM +0300, Kalle Valo wrote:
>> Antonio Quartulli <a@unstable.cc> writes:
>> 
>> > From: Antonio Quartulli <antonio@open-mesh.com>
>> >
>> > This patch was crafted long time ago to work around a key cache
>> > corruption problem on ath9k chipsets.
>> >
>> > The workaround consists in periodically triggering a worker that
>> > uploads all the keys to the HW cache. The worker is triggered also
>> > when the vif detects 21 undecryptable packets.
>> >
>> >
>> > This patch is based on top compat-wireless-2015-10-26.
>> >
>> >
>> > I was asked to release this code to the public and, since it is
>> > GPL, I am now doing it.
>> 
>> GPL? AFAICS ath9k is under ISC. I'm not sure what you mean with the
>> sentence above, but it's possible to interpret it so that this patch is
>> not under ISC license, which is problematic.
>
> Honestly, my sentence was just a way to say "it makes sense to release this
> patch to the public".

I was suspecting it was like that, I just wasn't sure.

> If it needs to be ISC in order to be merged, then it can be released under ISC.
>
> I don't want to enter a legal case :)

Me neither. But I can't apply patches with unclear license.

-- 
Kalle Valo
