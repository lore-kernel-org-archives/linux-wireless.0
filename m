Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:52412 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751572AbdLCHg7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 3 Dec 2017 02:36:59 -0500
Subject: Re: [v3] ath10k: rebuild crypto header in rx data frames
To: Ben Greear <greearb@candelatech.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
References: <1509035774-26553-1-git-send-email-kvalo@qca.qualcomm.com>
 <59b2ec22dc9c4db0bd30a65dba660b1c@euamsexm01a.eu.qualcomm.com>
 <154f13b8-1e77-dbe5-4cb0-81c534dbc40b@dd-wrt.com>
 <e98b52a7-ac14-81da-1fab-0c66befcf6d2@candelatech.com>
 <878telw65j.fsf@kamboji.qca.qualcomm.com>
 <73dae55c-4feb-b573-9d02-4942b201bec8@candelatech.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <82e96953-b83a-4618-1bad-06d0f4148d39@dd-wrt.com> (sfid-20171203_090825_912115_AD121D68)
Date: Sun, 3 Dec 2017 08:36:52 +0100
MIME-Version: 1.0
In-Reply-To: <73dae55c-4feb-b573-9d02-4942b201bec8@candelatech.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

you need a recent ath10k version. use the backports project to compile a 
recent ath10k/mac80211 for 3.17
or take a look into lede, it has a complete recent backports tree which 
can be used on 3.17 with small modifications

Am 02.12.2017 um 22:41 schrieb Ben Greear:
>
>
> On 12/02/2017 06:34 AM, Kalle Valo wrote:
>> Ben Greear <greearb@candelatech.com> writes:
>>
>>> Is this patch destined for stable?
>>>
>>> I was expecting to see it show up in the older stable releases,
>>> but it has not so far as far as I can tell.
>>
>> We are working on it, but not sure yet to which releases, it doesn't
>> directly apply to all active stable releases.
>
> I had no luck trying to apply it to a 3.17-ish ath10k.  Gave up after
> a bit and tried backporting the whole stack instead :P
>
> Thanks,
> Ben
>

-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
