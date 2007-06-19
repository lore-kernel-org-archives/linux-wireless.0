Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:49173 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751410AbXFSI7I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2007 04:59:08 -0400
Date: Tue, 19 Jun 2007 10:59:20 +0200
From: Jiri Benc <jbenc@suse.cz>
To: "Sandesh Goel" <sgoel@marvell.com>
Cc: "David Lamparter" <lists@diac24.net>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
Subject: Re: phy mode, channel -> freq mapping (was RE: more nl80211/iw tool  code comments)
Message-ID: <20070619105920.44f170f9@griffin.suse.cz>
In-Reply-To: <285925A4DF50FC408669C6302216838D024899@sc-exch02.marvell.com>
References: <1181759017.29767.117.camel@johannes.berg>
	<20070614142925.GA24414@charon.n2.diac24.net>
	<285925A4DF50FC408669C6302216838D024899@sc-exch02.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 18 Jun 2007 02:42:01 -0700, Sandesh Goel wrote:
> I have a high level comment on the whole phy mode, channel and frequency
> mapping business.
> 
> I think it is cleaner to define a parameter called BAND which can take
> values 2.4 GHz, 5 GHz and so on. Then, the combination of BAND and
> CHANNEL will uniquely define the operating frequency.

I completely agree. Actually, I thought about this in the past (see my
old patches for ieee80211) but it was not worth the effort to rewrite
mac80211 (as the changes would need to be quite invasive). But now,
with 802.11n, it's probably worth reconsidering.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
