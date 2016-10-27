Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm.newmedia-net.de ([217.113.179.122]:48828 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965089AbcJ0OzH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Oct 2016 10:55:07 -0400
To: Kalle Valo <kvalo@codeaurora.org>,
        Antonio Quartulli <a@unstable.cc>
References: <20161018083552.28592-1-a@unstable.cc>
 <87lgxbxl2d.fsf@purkki.adurom.net> <20161026141016.GB26376@prodigo.lan>
 <87bmy65nz8.fsf@kamboji.qca.qualcomm.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
        sw@simonwunderlich.de, Antonio Quartulli <antonio@open-mesh.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <62a2dc74-4a7c-d3d4-4170-4d5759b07ab3@dd-wrt.com> (sfid-20161027_165606_267532_E06CA534)
Date: Thu, 27 Oct 2016 09:54:10 +0200
MIME-Version: 1.0
In-Reply-To: <87bmy65nz8.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Subject: Re: [NOT FOR MERGE] ath9k: work around key cache corruption
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

all patches have a unclear license since most patches are not comming 
with any licence declaration ;-)

Am 27.10.2016 um 08:02 schrieb Kalle Valo:
> Antonio Quartulli <a@unstable.cc> writes:
>
>> On Wed, Oct 26, 2016 at 05:05:14PM +0300, Kalle Valo wrote:
>>> Antonio Quartulli <a@unstable.cc> writes:
>>>
>>>> From: Antonio Quartulli <antonio@open-mesh.com>
>>>>
>>>> This patch was crafted long time ago to work around a key cache
>>>> corruption problem on ath9k chipsets.
>>>>
>>>> The workaround consists in periodically triggering a worker that
>>>> uploads all the keys to the HW cache. The worker is triggered also
>>>> when the vif detects 21 undecryptable packets.
>>>>
>>>>
>>>> This patch is based on top compat-wireless-2015-10-26.
>>>>
>>>>
>>>> I was asked to release this code to the public and, since it is
>>>> GPL, I am now doing it.
>>> GPL? AFAICS ath9k is under ISC. I'm not sure what you mean with the
>>> sentence above, but it's possible to interpret it so that this patch is
>>> not under ISC license, which is problematic.
>> Honestly, my sentence was just a way to say "it makes sense to release this
>> patch to the public".
> I was suspecting it was like that, I just wasn't sure.
>
>> If it needs to be ISC in order to be merged, then it can be released under ISC.
>>
>> I don't want to enter a legal case :)
> Me neither. But I can't apply patches with unclear license.
>


-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Berliner Ring 101, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
