Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:44823 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbZHEScb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 14:32:31 -0400
Received: by gxk9 with SMTP id 9so380934gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2009 11:32:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A741B7B.7070200@gmx.de>
References: <4A720FE4.4020301@gmx.de> <1248990136.10154.10.camel@mj>
	<4A733CDE.4060801@gmx.de> <1249066564.20276.3.camel@mj> <4A737AFC.40301@gmx.de>
	<43e72e890907311622u1059be72y7c833f888b11cf56@mail.gmail.com>
	<4A741B7B.7070200@gmx.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 5 Aug 2009 11:32:12 -0700
Message-ID: <43e72e890908051132k764d7af1n3e7243824ae0dd4d@mail.gmail.com>
Subject: Re: [PATCH] compat-2.6: Makefile: fixed test expressions for target
	install
To: Joerg Albert <jal2@gmx.de>
Cc: Pavel Roskin <proski@gnu.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 1, 2009 at 3:39 AM, Joerg Albert<jal2@gmx.de> wrote:
> On 08/01/2009 01:22 AM, Luis R. Rodriguez wrote:
>>
>> Actually please do keep relying on /bin/bash, all the scripts on
>> compat-wireless do depend on /bin/bash, I don't expect users of
>> dash/etc to use compat-wireless.
>>
>> If we want to make compat-wireless be shell agnostic we'd need to
>> address all the other scripts. I rather not deal with that now unless
>> we really think that is also a good idea and someone is up for the
>> task.
>
> IMHO we could make bug fixes to the Makefile/scripts shell agnostic if it's
> not much effort and
> doesn't break readability, which is neither the case here.

Applied, thanks.

  Luis
