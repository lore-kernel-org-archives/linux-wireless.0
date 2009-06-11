Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:40429 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbZFKRO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 13:14:29 -0400
Received: by bwz9 with SMTP id 9so1603744bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2009 10:14:29 -0700 (PDT)
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, pierre@ossman.eu, san@google.com
Subject: Re: [PATCH/RFC 0/7] wl12xx SDIO interface
References: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
	<874oumyddk.fsf@litku.valot.fi>
	<b6c5339f0906111008y6e4cdc2cucf0283deb52ca2a5@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 11 Jun 2009 20:14:24 +0300
In-Reply-To: <b6c5339f0906111008y6e4cdc2cucf0283deb52ca2a5@mail.gmail.com> (Bob Copeland's message of "Thu\, 11 Jun 2009 13\:08\:10 -0400")
Message-ID: <87zlcewv4f.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> On Thu, Jun 11, 2009 at 11:54 AM, Kalle Valo<kalle.valo@iki.fi> wrote:
>> Sorry about the mess, I have been sitting on top of the wl1251 patches
>> way too long.
>
> No worries, yeah if you rebase them I'll test the result...

Excellent. Thanks for understanding :)

> patch 7 won't compile in a vanilla tree until the platform stuff is
> straightened out, but the rest should be OK for inclusion I think.

Ok, good to know. Let's try to find a generic solution for sdio
configuration so that wl12xx would work in different platforms. For
example also OpenPandora has wl1251 with sdio, it would be cool to
support that as well.

-- 
Kalle Valo
