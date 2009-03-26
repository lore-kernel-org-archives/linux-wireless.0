Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50835 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbZCZBmC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 21:42:02 -0400
Date: Wed, 25 Mar 2009 21:41:48 -0400
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/8] mac80211: fix A-MPDU queue assignment
Message-ID: <20090326014148.GA5543@bombadil.infradead.org> (sfid-20090326_024207_768447_CA149E90)
References: <20090323162834.154525349@sipsolutions.net> <20090323163052.038036544@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090323163052.038036544@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 23, 2009 at 05:28:36PM +0100, Johannes Berg wrote:
> Internally, mac80211 requires the skb's queue mapping to be set
> to the AC queue, not the virtual A-MPDU queue. This is not done
> correctly currently, this patch moves the code down to directly
> before the driver is invoked and adds a comment that it will be
> moved into the driver later.
> 
> Since this requires __ieee80211_tx() to have the sta pointer,
> make sure to provide it in ieee80211_tx_pending().
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Reviewed-by: Luis R. Rodriguez <lrodriguez@atheros.com>

  Luis
