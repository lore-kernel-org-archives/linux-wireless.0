Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:54580 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517AbZHDH0m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 03:26:42 -0400
Received: by bwz19 with SMTP id 19so2904441bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2009 00:26:42 -0700 (PDT)
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wl12xx: make irq handling interface specific
References: <20090804033908.GA1903@hash.localnet>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 04 Aug 2009 10:26:39 +0300
In-Reply-To: <20090804033908.GA1903@hash.localnet> (Bob Copeland's message of "Mon\, 3 Aug 2009 23\:39\:08 -0400")
Message-ID: <87hbwoniog.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> Hi Kalle,

Hi Bob,

> In addition to the warning below this patch also fixes oopses
> on rmmod due to active irqs after free.  Please consider
> including it with the original sdio series.

Thanks, this looks good and I'll take it.

> With this wl1251 is stable, scans, and sends probe requests;

Excellent.

> association probably needs resolution of the issue you already
> identified with spi.

I'm now back from my vacation and I'll start looking at spi part again.
I'll also take a look at the association problem and will fix it.

So this patch is only needed on top of the rebased sdio patchset I sent
few weeks ago to get sdio working? Or did I miss any patches? I'm just
being careful here because I want to get sdio support to 2.6.32 (if it's
ok for John) and there isn't that much time for that.

-- 
Kalle Valo
