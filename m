Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:41181 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab1HNCsv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 22:48:51 -0400
Received: by yie30 with SMTP id 30so2714572yie.19
        for <linux-wireless@vger.kernel.org>; Sat, 13 Aug 2011 19:48:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E4686C5.4060402@t-online.de>
References: <1313234481.2052.7.camel@localhost.localdomain>
	<4E4686C5.4060402@t-online.de>
Date: Sun, 14 Aug 2011 10:48:51 +0800
Message-ID: <CAJ-VmomuQ0oAgVywEtXBJBRwBTZ5o-3pREHOLm1Gs5=1O9BixQ@mail.gmail.com> (sfid-20110814_044853_939173_076ACB1B)
Subject: Re: [ath9k-devel] Packet loss regression with Atheros AR9280
From: Adrian Chadd <adrian@freebsd.org>
To: =?ISO-8859-1?Q?Richard_Sch=FCtz?= <r.schtz@t-online.de>
Cc: Jan Sundman <jan.sundman@aland.net>, robert@ocallahan.org,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13 August 2011 22:14, Richard Schütz <r.schtz@t-online.de> wrote:

> It looks like I'm having the same issue with an AR9285. In my university's
> wireless network the packet loss is noticeable higher with power management
> enabled. But at home everything is fine.

Can you please file a kernel bugzilla report for this, so it doesn't get lost?


Adrian
