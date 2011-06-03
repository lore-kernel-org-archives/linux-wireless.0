Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:41843 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab1FCNar (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 09:30:47 -0400
Date: Fri, 3 Jun 2011 08:30:41 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org,
	sedat.dilek@gmail.com
Subject: Re: [PATCH] ath5k: Disable fast channel switching by default
Message-ID: <20110603133041.GA27529@thinkpad-t410> (sfid-20110603_153051_038032_7C6DA60D)
References: <20110602000946.GA5951@makis>
 <BANLkTimbvSP4TxZU6C6vokqZMpW_ASaPCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BANLkTimbvSP4TxZU6C6vokqZMpW_ASaPCw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 03, 2011 at 11:59:41AM +0200, Sedat Dilek wrote:
> On Thu, Jun 2, 2011 at 2:09 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> > Disable fast channel change by default on AR2413/AR5413 due to
> > some bug reports (it still works for me but it's better to be safe).
> > Add a module parameter "fastchanswitch" in case anyone wants to enable
> > it and play with it.
> >
> > Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
> >
> 
> Already tested your initial patch from [1] against linux-next (next-20110601).

It's also been tested by a number of our users and verified to fix the
wireless problems they've been seeing in .38. I'd suggest Cc-ing stable
for .38.x and .39.x.

Seth
