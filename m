Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:36653 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214Ab2JDRqc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2012 13:46:32 -0400
Received: by mail-la0-f46.google.com with SMTP id h6so379506lag.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Oct 2012 10:46:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6280245.pW1SF1FHQv@bentobox>
References: <1349366701-23154-1-git-send-email-sven@narfation.org>
 <CAB=NE6XrTVQuAqGqD2wjyjN6ynyfB+yHXqBcAhRgOn=njBpAuA@mail.gmail.com> <6280245.pW1SF1FHQv@bentobox>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Thu, 4 Oct 2012 10:46:11 -0700
Message-ID: <CAB=NE6X7DytHOapoX1HyxSz7kEtaredsmtg_xZFUp=4VXjw8zA@mail.gmail.com> (sfid-20121004_194644_203176_36E46994)
Subject: Re: [PATCH] ath_hw: Use common REG_WRITE parameter order
To: Sven Eckelmann <sven@narfation.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 4, 2012 at 10:42 AM, Sven Eckelmann <sven@narfation.org> wrote:
> On Thursday 04 October 2012 10:29:59 Luis R. Rodriguez wrote:
>> On Thu, Oct 4, 2012 at 9:05 AM, Sven Eckelmann <sven@narfation.org> wrote:
>> > All defines for REG_WRITE in Atheros wireless drivers use the order "ah",
>> > "register" and "value". hw.c is the only file using the order "ah",
>> > "value" and "register". This inconsistent definition can easily lead to
>> > implementation errors.
>> >
>> > Signed-off-by: Sven Eckelmann <sven@narfation.org>
>>
>> Good catch! But can you resend specifying in your commit log that this
>> change is a no-op?
>
> I really don't know what you want from me here.

Just specify in the commit log that this change causes no functional changes.

  Luis
