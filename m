Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64761 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab1EDEcO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 00:32:14 -0400
Received: by wya21 with SMTP id 21so545949wya.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2011 21:32:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20110503T223125-677@post.gmane.org>
References: <1304438716-18800-1-git-send-email-mshajakhan@atheros.com>
	<loom.20110503T223125-677@post.gmane.org>
Date: Wed, 4 May 2011 10:02:13 +0530
Message-ID: <BANLkTimGwq-eij-PRKjy-o9T3niaHyxtgA@mail.gmail.com> (sfid-20110504_063217_404661_CE00F2EC)
Subject: Re: [RFC] mac80211: Fix a warning due to skipping tailroom
 reservation for IV
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Fabio Rossi <rossi.f@inwind.it>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 4, 2011 at 2:04 AM, Fabio Rossi <rossi.f@inwind.it> wrote:
> Mohammed Shafi Shajakhan <mshajakhan@...> writes:
>
>>
>> From: Mohammed Shafi Shajakhan <mshajakhan@...>
>>
>> The devices that require IV generation in software need tailroom
>> reservation  for ICVs used in TKIP or WEP encryptions.
>> Currently, decision to skip the tailroom reservation in the tx
>> path was taken only on whether driver wants MMIC to be generated
>> in software or not. Following patch appends IV generation check for
>> such decisions and fixes the following warning.
>
> I have been testing the patch for the last two hours. I don't have
> anymore WARNINGs.

thanks for testing, I will re-send it as a patch.

>
> Thanks,
> Fabio
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
