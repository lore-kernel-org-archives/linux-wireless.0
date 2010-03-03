Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:60574 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252Ab0CCT0I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 14:26:08 -0500
Date: Wed, 3 Mar 2010 14:06:35 -0500 (EST)
From: Nicolas Pitre <nico@marvell.com>
To: Deepak Saxena <dsaxena@plexity.net>
Cc: Holger Schurig <holgerschurig@gmail.com>,
	"dsaxena@laptop.org" <dsaxena@laptop.org>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] libertas: add auto auth mode feature
In-Reply-To: <20100303185231.GA14009@plexity.net>
Message-ID: <alpine.LFD.2.00.1003031404360.30204@xanadu.home>
References: <1267146996-3725-1-git-send-email-bzhao@marvell.com> <1267225266.14995.7.camel@localhost.localdomain> <20100301195948.GA19200@plexity.net> <201003021302.10039.holgerschurig@gmail.com> <20100303185231.GA14009@plexity.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 3 Mar 2010, Deepak Saxena wrote:

> We're currently on 2.6.31, which I guess is somewhat  pre-historic by 
> kernel development standards. We do have some patches to Libertas which 
> were co-developed along with Marvell to fix some bugs we've discovered
> during the XO-1.5 ramp up process and unfortunately we were on a really 
> tight release schedule and not all of those have been pushed upstream, 
> including some changes to the SDIO stack that were needed for proper
> suspend/resume support on the gen 2 laptops. I'll be working on moving 
> our kernel up to a newer version and will send up any patches that
> we need merged and will also work with our users to figure out what
> to do about mesh testing.

The SdIO patches are in the -mm tree and going to be merged for 2.6.34.


Nicolas
