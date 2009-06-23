Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2207 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbZFWTSb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2009 15:18:31 -0400
Date: Tue, 23 Jun 2009 15:16:10 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Gabor Juhos <juhosg@openwrt.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] mac80211: fix todo lock
Message-ID: <20090623191610.GA3571@hash.localnet>
References: <1245751007.4184.17.camel@johannes.local> <1245766038.21314.24.camel@johannes.local> <4A40F856.2010501@openwrt.org> <b6c5339f0906230951v9766914vdc1d76f85eb62feb@mail.gmail.com> <1245776114.21314.41.camel@johannes.local> <20090623183126.GA3337@hash.localnet> <1245783408.21314.43.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1245783408.21314.43.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 23, 2009 at 08:56:47PM +0200, Johannes Berg wrote:
> Subject: mac80211: fix todo lock
> 
> The key todo lock can be taken from different locks
> that require it to be _bh to avoid lock inversion
> due to (soft)irqs.

v3 works great!  Feel free to add

Tested-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com

