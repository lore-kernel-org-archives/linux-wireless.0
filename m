Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:39624 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbXLSGmz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 01:42:55 -0500
Date: Tue, 18 Dec 2007 22:45:10 -0800
From: Greg KH <gregkh@suse.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Mattias Nissler <mattias.nissler@gmx.de>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/8] debugfs: allow access to signed values
Message-ID: <20071219064510.GA18876@suse.de> (sfid-20071219_064258_880954_230A3F55)
References: <20071219001955.055692620@polimi.it>> <20071219012739.6dcdd150@morte>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071219012739.6dcdd150@morte>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 19, 2007 at 01:27:39AM +0100, Stefano Brivio wrote:
> Add debugfs_create_s{8,16,32,64}. For these to work properly, we need to remove
> a cast in libfs.
> 
> Cc: Johannes Berg <johannes@sipsolutions.net>
> To: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
> ---
> Greg,
> 
> here comes an implementation of debugfs_create_s{8,16,32,64} which avoids code
> duplication, suggested by Johannes Berg. We would need this to be merged to
> 2.6.25, as we need those functions to be available for rc80211-pid, the new
> mac80211 rate control algorithm.

Looks good to me, do you want me to add this to my tree and send it to
Linus when 2.6.25 opens up, or do you want this to go through the
wireless tree as you have patches relying on it?

Whatever works the best for you is fine for me.  If the wireless tree,
feel free to add:
	Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
to the patch.

thanks,

greg k-h
