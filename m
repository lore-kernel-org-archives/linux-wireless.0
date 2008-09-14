Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43218 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbYINB2Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Sep 2008 21:28:16 -0400
Date: Sat, 13 Sep 2008 20:52:57 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: The new regulatory code kills my wireless
Message-ID: <20080914005256.GA32339@tuxdriver.com> (sfid-20080914_032822_816503_37EBCD4E)
References: <48CAA8D6.1030605@lwfinger.net> <20080912174036.GC6134@tesla> <48CAB90C.5090302@lwfinger.net> <20080912191919.GA7722@tesla> <1221250959.5576.10.camel@johannes.berg> <1221272779.6695.22.camel@californication> <1221294810.3700.3.camel@johannes.berg> <1221324673.6695.31.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1221324673.6695.31.camel@californication>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 13, 2008 at 06:51:13PM +0200, Marcel Holtmann wrote:
> Hi Johannes,
> 
> > > I am pretty happy that you caught it, because that was my whole point
> > > from the discussion we had at OLS. The userspace part might not be in
> > > place and we must ensure that everything still works as before :)
> > 
> > I thought your point was that you wanted regulatory_hint_regdom(...)
> > that the driver can use to tell us what the EEPROM regulatory is, which
> > wouldn't have been affected by this bug :) But anyway, yeah, it's a bug.
> 
> of course I want regulatory_hint_regdom :)
> 
> I was just trying to make clear how important it is to make sure we work
> with a broken userspace or without userspace support at all

Which is, of course, why I asked Luis to implement the compatibility
option, and why I decided to let it cook for a bit in wireless-testing
before sending it to Dave for net-next-2.6... :-)

John
-- 
John W. Linville
linville@tuxdriver.com
