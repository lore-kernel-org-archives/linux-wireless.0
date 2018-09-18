Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:53178 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726838AbeIRPgy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Sep 2018 11:36:54 -0400
Subject: Re: [PATCH v3 00/11] NFC: A bunch of cleanups for st95hf
From: Daniel Mack <daniel@zonque.org>
To: sameo@linux.intel.com
Cc: linux-wireless@vger.kernel.org, colin.king@canonical.com,
        shikha.singh@st.com
References: <20180724095941.25777-1-daniel@zonque.org>
 <2b5303c6-d9b6-de58-690b-9508c139e7d6@zonque.org>
Message-ID: <9d92518c-b06f-d0cd-ab92-6210a319df7e@zonque.org> (sfid-20180918_120505_799251_4A96119D)
Date: Tue, 18 Sep 2018 12:04:59 +0200
MIME-Version: 1.0
In-Reply-To: <2b5303c6-d9b6-de58-690b-9508c139e7d6@zonque.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Samuel,

On 6/8/2018 12:38 PM, Daniel Mack wrote:
> On Tuesday, July 24, 2018 11:59 AM, Daniel Mack wrote:
>> This v3 of a series of patches for the ST95HF driver.
>>
>> Patch #1 reverts a change that I have submitted earlier and which is
>> sitting in nfc-next already. Given that the tree hasn't been sent out
>> for being merged yet, it could also still be removed with rebasing, in
>> which case #1 is not necessary of course.
>>
>> The changes are all rather simple and are explained in their individual
>> commit logs.
>>
>> Note that this series builds upon the patch titled "nfc: st95hf: remove
>> redundant pointers 'dev' and 'nfcddev'" that Colin posted the other day.
> 
> Could you still apply this set for 4.19?

Hmm it seems it has missed the merge window again.

May I ask whether you still consider applying these to your tree and get 
it merged?


Thanks,
Daniel
