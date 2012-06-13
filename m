Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm34-vm6.bullet.mail.bf1.yahoo.com ([72.30.239.78]:35496 "HELO
	nm34-vm6.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754256Ab2FMSox (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 14:44:53 -0400
Message-ID: <1339612748.69001.YahooMailClassic@web161703.mail.bf1.yahoo.com> (sfid-20120613_204456_677510_18F2E6A2)
Date: Wed, 13 Jun 2012 11:39:08 -0700 (PDT)
From: hong zhang <henryzhang62@yahoo.com>
Subject: Re: poor performance with W2CBW003 (Marvell 8686)
To: Andreas Kemnade <andreas@kemnade.info>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	dsd@laptop.org, libertas-dev@lists.infradead.org
In-Reply-To: <20120613194254.076268a8@kemnade.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You have to identify problem caused by 
SDIO host controller or wifi driver.

If driver is working well in x86 with Roch SDIO, that means wifi driver is ok. 

You have to find out
1. SDIO interface if using Interrupt or PIO
2. 1 bit or 4 bit
3. TI BSP SDIO controller 

--- On Wed, 6/13/12, Andreas Kemnade <andreas@kemnade.info> wrote:

> From: Andreas Kemnade <andreas@kemnade.info>
> Subject: Re: poor performance with W2CBW003 (Marvell 8686)
> To: "hong zhang" <henryzhang62@yahoo.com>
> Cc: "Dan Williams" <dcbw@redhat.com>, linux-wireless@vger.kernel.org, dsd@laptop.org, libertas-dev@lists.infradead.org
> Date: Wednesday, June 13, 2012, 12:42 PM
> Hi,
> 
> On Wed, 13 Jun 2012 10:06:54 -0700 (PDT)
> hong zhang <henryzhang62@yahoo.com>
> wrote:
> 
> > > 4 bit is supported.
> > > The hardware does not impose unresolvable
> limitations, the
> > > 2.6.32 kernel
> > > gives high performance. But since that kernel is
> not
> > > mainstream, it is
> > > very hard to find out which patch gives the
> slowdown. git
> > > bisect
> > > is not very useful in that situation.
> > > SD memory card reading speed is always ok (on
> another of the
> > > integrated
> > > sd host controllers).
> > 
> > Have you tested receive throughput? Any difference
> between TX and Rx throughput? 
> > 
> I tested both.
> No significant difference with 3.x.
> 
> Greetings
> Andreas Kemnade
> 
