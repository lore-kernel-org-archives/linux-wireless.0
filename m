Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f211.google.com ([209.85.220.211]:33173 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbZFPQ2H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 12:28:07 -0400
Received: by fxm7 with SMTP id 7so789660fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2009 09:28:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890906152133x49e8a072hfce9e48f82094f35@mail.gmail.com>
References: <3ace41890906151936s3f0d70fcx6f42bfddf07dd70e@mail.gmail.com>
	 <43e72e890906152133x49e8a072hfce9e48f82094f35@mail.gmail.com>
Date: Tue, 16 Jun 2009 17:28:07 +0100
Message-ID: <3ace41890906160928y8c43fe2m96844c7361174a89@mail.gmail.com>
Subject: Re: vid/pid sorting patch? (Re: [PATCH] zd1211rw: adding 083a:e503 as
	a ZD1211B device)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 16, 2009 at 5:33 AM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> On Mon, Jun 15, 2009 at 7:36 PM, Hin-Tak Leung<hintak.leung@gmail.com> wrote:
>> Hiya,
>>
>> The zd1211rw vid/pid list is getting a bit unruly - would it be
>> acceptable to submit a non-code-changing patch just to sort the ids?
>> It would just be tidier and make it easier to see what id is already
>> in and what is not, and also make it obvious where new changes should
>> be inserted. I know this affects git blame and other log searching
>> usage so may not be entirely desirable.
>
> Development on wireless-testing is always open, just send what you
> have and don't worry about where it can get applied.
>
>  Luis

Okay - I'll submit a patch to sort the vid/pid's in zd1211rw in hex
order soon then.

Hin-Tak
