Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm12-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.140]:34890 "HELO
	nm12-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754318Ab2FNQLI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 12:11:08 -0400
Message-ID: <1339690266.19412.YahooMailClassic@web161704.mail.bf1.yahoo.com> (sfid-20120614_181112_225722_708F9826)
Date: Thu, 14 Jun 2012 09:11:06 -0700 (PDT)
From: hong zhang <henryzhang62@yahoo.com>
Subject: Re: poor performance with W2CBW003 (Marvell 8686)
To: Andreas Kemnade <andreas@kemnade.info>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	dsd@laptop.org, libertas-dev@lists.infradead.org
In-Reply-To: <20120614074545.105a459d@kemnade.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bit mode and interrupt or PIO are configured in SDIO hoster side.
Not in driver side.

--- On Thu, 6/14/12, Andreas Kemnade <andreas@kemnade.info> wrote:

> From: Andreas Kemnade <andreas@kemnade.info>
> Subject: Re: poor performance with W2CBW003 (Marvell 8686)
> To: "hong zhang" <henryzhang62@yahoo.com>
> Cc: "Dan Williams" <dcbw@redhat.com>, linux-wireless@vger.kernel.org, dsd@laptop.org, libertas-dev@lists.infradead.org
> Date: Thursday, June 14, 2012, 12:45 AM
> Hi,
> 
> On Wed, 13 Jun 2012 11:39:08 -0700 (PDT)
> hong zhang <henryzhang62@yahoo.com>
> wrote:
> 
> > You have to identify problem caused by 
> > SDIO host controller or wifi driver.
> > 
> > If driver is working well in x86 with Roch SDIO, that
> means wifi driver is ok. 
> > 
> > You have to find out
> > 1. SDIO interface if using Interrupt or PIO
> 
> Hmm, very interesting point, of course, there are
> interrupts. But after reading
> the commit logs in the patched 2.6.32 kernel I see there is
> a patch enabling
> asynchronous *sdio* interrupts. That looks clearly
> suspicious. 
> 
> > 2. 1 bit or 4 bit
> 
> Hmm, 4bit.
> 
> Greetings
> Andreas Kemnade
> 
