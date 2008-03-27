Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:35113 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbYC0Lvq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 07:51:46 -0400
Date: Thu, 27 Mar 2008 07:51:25 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Helge Deller <deller@gmx.de>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, mcgrof@gmail.com
Subject: Re: ath5k aborts wireless connections
Message-ID: <20080327115125.GA10265@hash.localnet> (sfid-20080327_115149_723574_3432287C)
References: <200803221129.59090.deller@gmx.de> <40f31dec0803251116s4b39b1dagfa9c3941b706a52f@mail.gmail.com> <b6c5339f0803251216pd355868n90c845c01a8aa84e@mail.gmail.com> <200803252111.05726.deller@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200803252111.05726.deller@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 25, 2008 at 09:11:05PM +0100, Helge Deller wrote:
> On Tuesday 25 March 2008, Bob Copeland wrote:
> > On Tue, Mar 25, 2008 at 2:16 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> > > Hello ppl, sory for the delay ;-)
> > >
> > >  Are you using encryption ? I haven't got such errors on my tests (it
> > >  might be that my setup is really simple) so far...
> > 
> > I can't speak for Helge, but in my case yes - WPA-TKIP.
> 
> Same here. WPA-PSK & TKIP.

So, I turned off encryption here and did not get any "invalid Michael
MIC" messages while doing a large apt-get upgrade overnight.  I do get 
random pauses but nothing else in my dmesg.

Helge, can you confirm disabling encryption makes the reset go away?

-- 
Bob Copeland %% www.bobcopeland.com 

