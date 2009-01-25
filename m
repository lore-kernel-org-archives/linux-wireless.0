Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:30184 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbZAYQrd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2009 11:47:33 -0500
Received: by wf-out-1314.google.com with SMTP id 27so6499217wfd.4
        for <linux-wireless@vger.kernel.org>; Sun, 25 Jan 2009 08:47:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1232901917.3837.0.camel@johannes.local>
References: <20090124081223.50440@gmx.net>
	 <b6c5339f0901250841r22635bd7q40532891293a6744@mail.gmail.com>
	 <1232901917.3837.0.camel@johannes.local>
Date: Sun, 25 Jan 2009 11:47:31 -0500
Message-ID: <b6c5339f0901250847i5f9f98bcl4ebec04027d7c93c@mail.gmail.com> (sfid-20090125_174738_481629_9C3F206C)
Subject: Re: [PATCH] ath5k: Set TSF fix
From: Bob Copeland <bcopeland@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Alina Friedrichsen <x-alina@gmx.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 25, 2009 at 11:45 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>> Perhaps there is an internal latch on this pair; that may explain why
>> you need to write low->high order.
>
> Either way, I think the changelog should back up the claim by
> _something_. Even if it's just "tested on device XXX, old way doesn't
> work, new way does" or "looked at legacy HAL code" or ...

Agreed, "tested on..." would be good.  I looked at the HAL and it
doesn't have a set tsf function, only reset.

-- 
Bob Copeland %% www.bobcopeland.com
