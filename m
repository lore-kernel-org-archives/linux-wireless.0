Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hupie.dyndns.org ([80.101.237.101]:56357 "EHLO hupie.dyndns.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752099AbcJZPPt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 11:15:49 -0400
Subject: Re: [ath9k-devel] [NOT FOR MERGE] ath9k: work around key cache
 corruption
To: Kalle Valo <kvalo@codeaurora.org>,
        Antonio Quartulli <a@unstable.cc>
References: <20161018083552.28592-1-a@unstable.cc>
 <87lgxbxl2d.fsf@purkki.adurom.net>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
        Antonio Quartulli <antonio@open-mesh.com>
From: Ferry Huberts <mailings@hupie.com>
Message-ID: <8dbef9e2-129e-ee65-0906-4ed9020fa712@hupie.com> (sfid-20161026_171553_631983_3E74703E)
Date: Wed, 26 Oct 2016 16:43:00 +0200
MIME-Version: 1.0
In-Reply-To: <87lgxbxl2d.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

do a grep in the kernel: dual license bsd/gpl

On 26/10/16 16:05, Kalle Valo wrote:
> Antonio Quartulli <a@unstable.cc> writes:
>
>> From: Antonio Quartulli <antonio@open-mesh.com>
>>
>> This patch was crafted long time ago to work around a key cache
>> corruption problem on ath9k chipsets.
>>
>> The workaround consists in periodically triggering a worker that
>> uploads all the keys to the HW cache. The worker is triggered also
>> when the vif detects 21 undecryptable packets.
>>
>>
>> This patch is based on top compat-wireless-2015-10-26.
>>
>>
>> I was asked to release this code to the public and, since it is
>> GPL, I am now doing it.
>
> GPL? AFAICS ath9k is under ISC. I'm not sure what you mean with the
> sentence above, but it's possible to interpret it so that this patch is
> not under ISC license, which is problematic.
>

-- 
Ferry Huberts
