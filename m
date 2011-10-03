Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56394 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756920Ab1JCUBM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 16:01:12 -0400
Received: by qyk30 with SMTP id 30so2549613qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Oct 2011 13:01:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1125417094.1836.1317285426615.JavaMail.root@idefix>
References: <CAB=NE6U6qmYbvHPTWGTqOdXtuxbKYbUzZXNiE6POOX9QZNRWAg@mail.gmail.com>
 <1125417094.1836.1317285426615.JavaMail.root@idefix>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Mon, 3 Oct 2011 13:00:52 -0700
Message-ID: <CAB=NE6UKYPu0GtsLrP0sXHESuhVba0oqrqEWVedXqv-cjhbB8w@mail.gmail.com> (sfid-20111003_220116_134654_B08D58CE)
Subject: Re: Regulatory revamp status
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Boris Presman <boris.presman@ti.com>,
	Assaf Azulay <assaf@ti.com>,
	Michael Green <green@qca.qualcomm.com>,
	David Quan <dquan@qca.qualcomm.com>,
	Kevin Hayes <hayes@qca.qualcomm.com>,
	Arun Venkataraman <arunvenk@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 29, 2011 at 1:37 AM, Zefir Kurtisi
<zefir.kurtisi@neratec.com> wrote:
> Thanks for the update.
>
> To me it looks not reasonable to mix in between the two approaches: either we assume countrycodes use the same DFS region for all channels, or each channel/band needs to have its own. Otherwise I feel that a DFS region bitmap would give a semi-flexible compromise that might end up being insufficient to represent some fancy countrycodes.

I reviewed this with Michael. The answer is we only want one DFS
region per country, that's it. I'll respin my DFS patches.

  Luis
