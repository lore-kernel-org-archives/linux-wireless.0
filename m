Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:34875 "EHLO
        mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759393AbdACPlo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jan 2017 10:41:44 -0500
Received: by mail-yw0-f180.google.com with SMTP id v81so189222158ywb.2
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jan 2017 07:41:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <942b4775-6027-2b99-84c7-37b7cde124b9@au1.ibm.com>
References: <2029482.jt8IarKZJs@calvin> <942b4775-6027-2b99-84c7-37b7cde124b9@au1.ibm.com>
From: Alexander Morozov <alexandr.morozov@docker.com>
Date: Tue, 3 Jan 2017 07:41:43 -0800
Message-ID: <CA+EAOG50cJM_Sg5Q+G+LCfCgUwZ92BH5mcctUvFeWeT9aPAS7Q@mail.gmail.com> (sfid-20170103_164256_538038_4306C7CB)
Subject: Re: kernel 4.9 iwlwifi startup error
To: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Cc: Fabio Coatti <fabio.coatti@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a similar problem on Gentoo. But in my case, it just can't load
firmware: "no suitable firmware found". I've tried to reinstall
firmware with no luck. Everything is ok with 4.8.6.

On Mon, Jan 2, 2017 at 6:42 PM, Andrew Donnellan
<andrew.donnellan@au1.ibm.com> wrote:
> On 02/01/17 21:12, Fabio Coatti wrote:
>>
>> Hi all,
>> I'm using kernel 4.9 and maybe half of the times I boot my laptop I get
>> the
>> error reported below, and the wifi does not work. I have to remove iwlwifi
>> (like
>> modprobe -r iwldvm iwlwifi) and insert it again to get things workig
>> again.
>> This seems a bit random, it does not happens all the times so it could be
>> a
>> timing issue or even a flaky hardware (unlikely, as I see only this issue
>> with
>> wifi, once it starts it works just fine)
>> I'm pretty sure to have seen the same behaviour at some point in 4.8.X
>> release, but right now I lost the related notes.
>> Environment:
>> Distro: gentoo
>> gcc 5.4.0
>> HW: Hewlett-Packard HP EliteBook Folio 9470m/18DF, BIOS 68IBD Ver. F.63
>> 04/26/2016
>> Intel(R) Core(TM) i5-3427U CPU @ 1.80GHz
>> Network controller: Intel Corporation Centrino Advanced-N 6235 (rev 24)
>>
>> Of course if more info is needed, just drop me a note.
>>
>> I'm not subscribed to mailing lists, so please keep me in CC: for any
>> information request.
>>
>> Many thanks.
>
>
> I've so far seen this once on my laptop, a Samsung NP540U3C (don't have it
> with me right now, so I'm not sure what the wifi chipset is), running with a
> Debian 4.9 kernel.
>
> --
> Andrew Donnellan              OzLabs, ADL Canberra
> andrew.donnellan@au1.ibm.com  IBM Australia Limited
>
