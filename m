Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:33387 "EHLO
        mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751137AbdCPJw5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 05:52:57 -0400
Received: by mail-vk0-f47.google.com with SMTP id d188so20992407vka.0
        for <linux-wireless@vger.kernel.org>; Thu, 16 Mar 2017 02:52:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <02e3d7706b82480d86fb2fcff76969b3@euamsexm01a.eu.qualcomm.com>
References: <CAPXt_dabk8KNL0HTHZJfoHT+93ZS+3R31tVEPb4zpKJWE65cMw@mail.gmail.com>
 <02e3d7706b82480d86fb2fcff76969b3@euamsexm01a.eu.qualcomm.com>
From: Rostyslav Khudolii <rkhudolii@airtame.com>
Date: Thu, 16 Mar 2017 10:46:18 +0100
Message-ID: <CAPXt_db72TErN5CcAfVj7FC+F5eTajqwOTgK2PkNnqQC-=QvOQ@mail.gmail.com> (sfid-20170316_105300_714339_9F71163C)
Subject: Re: ath6kl: Remove old 802.11a-only channels
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl@lists.infradead.org, linux-wireless@vger.kernel.org,
        Attila Sukosd <attila@airtame.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 March 2017 at 10:36, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Rostyslav Khudolii <rkhudolii@airtame.com> wrote:
>> Channels 34/38/42/46 can only be used for compatibility with
>> old devices sold in Japan. Modern products, such as AR6003/AR6004
>> don't support these channels.
>> Keeping them in the upstream is error prone and requires full
>> network stack support.
>> A custom patch should be used in case such compatibility is required.
>>
>> Signed-off-by: Rostyslav Khudolii <rkhudolii@airtame.com>
>> Cc: Attila Sukosd <attila@airtame.com>
>
> For some reason the patch didn't apply to ath.git, I had manually recreate it.
> Please review carefully that the patch is correct now:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=cd63adf640e39c2ba013cba91b29700f3f593b9c
>
> Also I added your description of the bug to the commit log.
>
> --
> https://patchwork.kernel.org/patch/9615199/
>
> Documentation about submitting wireless patches and checking status
> from patchwork:
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
>

It's correct.
