Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:53782 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752331AbZAWRmt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 12:42:49 -0500
Date: Fri, 23 Jan 2009 09:40:50 -0800
From: Greg KH <greg@kroah.com>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: Bob Copeland <me@bobcopeland.com>, Keir <keirlawson@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ath5k mesh in 2.6.28?
Message-ID: <20090123174050.GA12042@kroah.com> (sfid-20090123_184253_352770_662CC3C8)
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

Which stable kernel should this be for, .27 or .28 or both?

thanks,

greg k-h
