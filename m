Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47207 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab0FRSpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jun 2010 14:45:12 -0400
Date: Fri, 18 Jun 2010 14:43:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Pekka Pietikainen <pp@ee.oulu.fi>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Michael Green <Michael.Green@atheros.com>,
	David Quan <David.Quan@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: wireless-regdb: FI/CZ updates
Message-ID: <20100618184335.GC6282@tuxdriver.com>
References: <20100525132035.GA863@ee.oulu.fi>
 <AANLkTik7vyllINxzeMN2HPD7cqpQH2tZegc3-VsNa8da@mail.gmail.com>
 <20100528124258.GA27491@ee.oulu.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100528124258.GA27491@ee.oulu.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 28, 2010 at 03:42:58PM +0300, Pekka Pietikainen wrote:
> On Wed, May 26, 2010 at 11:30:37AM -0700, Luis R. Rodriguez wrote:
> > Pekka, please remove these changes from this patch, you want to make
> > your patches atomic, with only one purpose to help the review process
> > easier. You stashed changes to CZ & FI on one... You also switched
> > from dBm to mW and note how you actually did change the EIRP here for
> > only one for FI. Please provide a separate set of patches for that for
> > FI. If you want to switch to mW for all of the entries for FI first do
> > that, and then on a separate patch make the actual regulatory changes
> > so this is crystal clear for the review process.
> Okie
> 
> Looking at it a bit more probably makes sense to codify the current
> harmonized EU rules, and then just for each country note that they've
> actually implemented it in their local legislation (I checked FI, SE and
> CZ).  Everyone should have, but some are pretty slow at this, or
> have some special national interests...
> 
> The legislation uses mW, so that's the reason I switched them.
> 
> For review (first hit on google for the decision number
> should find the official text), I can do patches once someone
> has verified, that this is what the legalese actually says:
> 
> # EU Commission Decision 2009/381/EC
>        (2400 - 2483.5 @ 40), (N/A, 100mW)
> # 2005/513/EC and 2007/90/EC, 5250 and 5470 can be doubled if TPC is in use
>        (5150 - 5250 @ 40), (N/A, 200mW), NO-OUTDOOR
>        (5250 - 5350 @ 40), (N/A, 100mW), NO-OUTDOOR, DFS
>        (5470 - 5725 @ 40), (N/A, 500mW), DFS

Ping?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
