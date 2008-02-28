Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40953 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254AbYB1XlT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2008 18:41:19 -0500
Date: Thu, 28 Feb 2008 18:40:58 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, bruno@thinktube.com, me@bobcopeland.com
Subject: Re: [PATCH 7/8] ath5k: Minor code review to match regdumps
Message-ID: <20080228234058.GA3396@infradead.org> (sfid-20080228_234123_559595_35E9CE95)
References: <f6d5bb6d43d1ddfb60d5ed8b8d6ee472643eafd8.1204236793.git.mcgrof@winlab.rutgers.edu> <3d16ff86ebf71f749d3cc0b4219ebe89c0e4585d.1204236793.git.mcgrof@winlab.rutgers.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3d16ff86ebf71f749d3cc0b4219ebe89c0e4585d.1204236793.git.mcgrof@winlab.rutgers.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 28, 2008 at 06:00:24PM -0500, Luis R. Rodriguez wrote:
>  /*
> + * ath5k_hw_reset_ar5212 - reset helper for ar5212
> + *
> + * @ah: the &struct ath5k_hw
> + * @channel: the &ieee80211_channel
> + *
> + * This is a helper to ath5k_hw_reset() for AR5212.
> + */
> +static inline void ath5k_hw_reset_init_ar5212(struct ath5k_hw *ah,
> +	struct ieee80211_channel *channel)

s/inline // please

