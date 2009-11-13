Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:40387 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757001AbZKMU0U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 15:26:20 -0500
Received: by iwn8 with SMTP id 8so2924660iwn.33
        for <linux-wireless@vger.kernel.org>; Fri, 13 Nov 2009 12:26:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e890911120732m74dbe2d4m14dd146cd0fb3016@mail.gmail.com>
References: <02a401ca6370$51fa0ff0$f5ee2fd0$@kaist.ac.kr> <43e72e890911120732m74dbe2d4m14dd146cd0fb3016@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 13 Nov 2009 12:26:05 -0800
Message-ID: <43e72e890911131226i1a58560haeddca42c76bc1a9@mail.gmail.com>
Subject: Re: ath9k: Unknown symbol
To: Jinsung Lee <ljs@netsys.kaist.ac.kr>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 12, 2009 at 7:32 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Thu, Nov 12, 2009 at 12:15 AM, Jinsung Lee <ljs@netsys.kaist.ac.kr> wrote:
>> Hi, all.
>>
>> I installed compat-wireless-2009-11-12 and compiled successfully.
>> But when inputting the command "modprobe ath9k", I saw the following
>> message:
>>
>> FATAL: Error inserting ath9k
>> (/lib/modules/2.6.32-020632rc6-generic/updates/drivers/net/wireless/ath/ath9
>> k/ath9k.ko): Unknown symbol in module, or unknown parameter (see dmesg)
>>
>> And dmesg shows the following:
>>
>> [582122.800191] ath9k: Unknown symbol ath9k_cmn_rx_skb_preprocess
>> [582122.803675] ath9k: Unknown symbol ath9k_cmn_rx_skb_postprocess
>>
>> Actually, I haven't seen this kind of message before.
>> Is there any workaround solution for this?
>
> compat-wireless just needs to be updated, I'll take care of this.

Ok try the new tarball release.

git-describe for wireless-testing.git says: v2.6.32-rc6-41741-ga601a39
This is a bleeding edge compat-wireless release based on: master-2009-11-11
This is compat-release: master-2009-11-11

  Luis
