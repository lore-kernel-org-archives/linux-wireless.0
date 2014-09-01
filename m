Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:61755 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbaIATr2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 15:47:28 -0400
Received: by mail-ie0-f178.google.com with SMTP id at1so6570310iec.37
        for <linux-wireless@vger.kernel.org>; Mon, 01 Sep 2014 12:47:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5404C490.9080008@lwfinger.net>
References: <CAG0uzYMST12cBwX9v_RAmh+d1muFhQEHSHUhdfMRrTGnPPJq=w@mail.gmail.com>
	<5404BDCE.1050007@lwfinger.net>
	<CAG0uzYM77jdNNbQem_uVN-k5hk2Yh=PaHj=pBXbesocY_9ZHsA@mail.gmail.com>
	<5404C490.9080008@lwfinger.net>
Date: Tue, 2 Sep 2014 01:17:28 +0530
Message-ID: <CAG0uzYN0ks1P-EhdKaddBExv249O6LfuTkORBZRCgJ-O0LjFPQ@mail.gmail.com> (sfid-20140901_214736_736240_9D6024C5)
Subject: Re: Help needed to interpret kernel warning and call trace
From: Amitav Mohanty <amitavmohanty01@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you for clarifying. Appreciate your help.

Regards,
Amitav

On Tue, Sep 2, 2014 at 12:40 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 09/01/2014 01:55 PM, Amitav Mohanty wrote:
>> Hey Larry
>>
>> Thank you for the prompt reply. I am not a kernel dev. My intension
>> was to seek help and understand how this impacts my system. I looked
>> for removing the taint. However, it seems Nvidia driver is the one
>> that is tainting the kernel. Since this is the laptop I use for work,
>> I don't think I can remove NVidia driver. If I understand correctly,
>> using the Nouveau driver instead the proprietary one should remove the
>> taint. Is there any other way I can help ?
>
> Yes, nvidia does taint the kernel. If nouveau works, that would remove the taint.
>
> The warning will have exactly zero impact on your system, other than to pollute
> your logs.
>
> Larry
>
>
