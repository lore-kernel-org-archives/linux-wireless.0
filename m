Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42821 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab2KMR0H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 12:26:07 -0500
Received: by mail-ie0-f174.google.com with SMTP id k13so11075463iea.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2012 09:26:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50A186BD.6060908@lwfinger.net>
References: <1352757511-26957-1-git-send-email-maxtram95@gmail.com>
 <1352757511-26957-16-git-send-email-maxtram95@gmail.com> <50A186BD.6060908@lwfinger.net>
From: Maxim Mikityanskiy <maxtram95@gmail.com>
Date: Tue, 13 Nov 2012 19:25:46 +0200
Message-ID: <CAKErNvrxoc=QFaJ8Tkhm=gHQhLPVU3Mjf5h4rOF1oqOR-d+5fw@mail.gmail.com> (sfid-20121113_182611_988600_E7C3446E)
Subject: Re: [PATCH 15/17] Removed unused fields in r8180_priv
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Greg Kroah-Hartman <greg@kroah.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/11/13 Larry Finger <Larry.Finger@lwfinger.net>:
> On 11/12/2012 03:58 PM, Maxim Mikityanskiy wrote:
>>
>> Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
>> ---
>>   r8180.h       |   10 ----------
>>   r8180_core.c  |   49 +++----------------------------------------------
>>   r8185b_init.c |    6 ++----
>>   3 files changed, 5 insertions(+), 60 deletions(-)
>
>
> This patch failed to apply, even after the directory level was fixed. A
> wiggle run fixed it with no manual intervention, but there is some kind of
> problem. My base system is the staging tree, with a pull today.
>
> Larry
>

Maybe, that's because I used linux-3.6.2 as base for my patches. I'll
resend patches that should apply cleanly to today's tree.
