Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45790 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab1FNLrg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2011 07:47:36 -0400
Received: by ywe9 with SMTP id 9so2515543ywe.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 04:47:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimZFU_g5Ee4Ajh9MyFmWCvtj-Firw@mail.gmail.com>
References: <BANLkTikFvkUj=JFrCsffz6Z78KdAEw-t0A@mail.gmail.com>
	<20110613132009.GA7133@redhat.com>
	<BANLkTi=eKBcV5OjP0qqLe6n9GsiwhYLejg@mail.gmail.com>
	<20110614100918.GA4450@redhat.com>
	<BANLkTimZFU_g5Ee4Ajh9MyFmWCvtj-Firw@mail.gmail.com>
Date: Tue, 14 Jun 2011 19:47:35 +0800
Message-ID: <BANLkTine2HDAwUnd5jJ=mwL25bJo-7zJSg@mail.gmail.com> (sfid-20110614_134740_671649_B9664201)
Subject: Re: APSM, AR9285 and bus hangs
From: Adrian Chadd <adrian@freebsd.org>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Jonathan Nieder <jrnieder@gmail.com>,
	ath9k-devel@venema.h4ckr.net, Tony Houghton <h@realh.co.uk>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	camilo@mesias.co.uk, Rajkumar Manoharan <rmanoharan@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14 June 2011 19:44, Mohammed Shafi <shafi.wireless@gmail.com> wrote:

> I had verified with the internal code base whether this is being done,
> unfortunately no and at least I had tested this patch in my lenovo
> T400 machine it did not cause any issue. this might fix the issue for
> the specific platform but I am not sure whether this will not cause
> any problems in other platforms. these sort for Workarounds were done
> based on testing in different platforms.
> Adrian you have any thoughts?

I don't have any new thoughts, no. I think it's more likely something
to do with how the bus is being setup, how APSM is being used, how
power saving in general is handled, quirks of that chipset (all the
laptops with problems have been a specific AMD chipset, right?)

Unfortunately I don't know anywhere near enough about the goings on
with power saving/APSM on Linux. If someone would like to get us in
contact with the relevant developers, we could likely have a more
constructive discussion.

(And after exams please, I don't have brain cycles to spend thoroughly
thinking about this until late June..)


Adrian
