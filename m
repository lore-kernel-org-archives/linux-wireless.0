Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:47235 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933145AbXBWQxG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Feb 2007 11:53:06 -0500
Date: Fri, 23 Feb 2007 17:53:04 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] d80211: Split antenna selection into TX and RX  antenna
Message-ID: <20070223175304.13dac069@griffin.suse.cz>
In-Reply-To: <200702211806.44032.IvDoorn@gmail.com>
References: <200702211702.46661.IvDoorn@gmail.com>
	<200702211727.55015.IvDoorn@gmail.com>
	<200702211736.32461.mb@bu3sch.de>
	<200702211806.44032.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 21 Feb 2007 18:06:43 +0100, Ivo van Doorn wrote:
> On Wednesday 21 February 2007 17:36, Michael Buesch wrote:
> > On Wednesday 21 February 2007 17:27, Ivo van Doorn wrote:
> > > -	int antenna_sel;
> > > +	int antenna_sel_tx;
> > > +	int antenna_sel_rx;
> > 
> > Hm, u8 here, too? The rest of this patch is ok.
> 
> Signed-off-by: Ivo van Doorn<IvDoorn@gmail.com>

Applied, thanks!

 Jiri

-- 
Jiri Benc
SUSE Labs
