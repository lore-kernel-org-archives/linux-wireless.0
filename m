Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:54655 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752076AbZA1CBS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 21:01:18 -0500
Date: Tue, 27 Jan 2009 17:38:52 -0800
From: Greg KH <greg@kroah.com>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: Bob Copeland <me@bobcopeland.com>, Keir <keirlawson@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ath5k mesh in 2.6.28?
Message-ID: <20090128013852.GB12223@kroah.com> (sfid-20090128_030126_149445_939E6AA7)
References: <e27b78a40901230530h192a8030l6905089df2a5822d@mail.gmail.com> <b6c5339f0901230717h605d2fbaibda8b720c6191abf@mail.gmail.com> <45e8e6c40901230929r6efbf19xbe2c32bef92db8e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <45e8e6c40901230929r6efbf19xbe2c32bef92db8e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 23, 2009 at 09:29:22AM -0800, Andrey Yurovsky wrote:
> Sorry, looks like that's my mistake (I thought the patch had made it
> in).  Greg -- thanks for queuing the patch.
> 
> For completeness, I should note that ath5k mesh is later broken by
> "ath5k: Update PCU code" and fixed again (hopefully both in by
> 2.6.29!) by "ath5k: Correct usage of AR5K_CFG_ADHOC"
> 
> Greg and Keir -- I also suggest Brian's patch, "mac80211: decrement
> ref count to netdev after launching mesh discovery", commit
> 05188d21d21dc8976bff13a9ca73a230eef86d40 for stable as it should apply
> there and fixes a bug that will sometimes prevent module unload if a
> mesh interface was active.

I think you mean 5dc306f3bd1d4cfdf79df39221b3036eab1ddcf3 instead, there
is no 05188d21d21dc8976bff13a9ca73a230eef86d40 in Linus's tree :)

queued up,

greg k-h
