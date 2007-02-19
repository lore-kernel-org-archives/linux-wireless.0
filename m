Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:34140 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932633AbXBSUYj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 15:24:39 -0500
Date: Mon, 19 Feb 2007 21:24:38 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] d80211: Fix skb panic during passive scan
Message-ID: <20070219212438.162383bb@griffin.suse.cz>
In-Reply-To: <200702181416.24396.IvDoorn@gmail.com>
References: <200702181416.24396.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 18 Feb 2007 14:16:24 +0100, Ivo van Doorn wrote:
> Only add the extra_tx_headroom to the len when allocating
> the sk_buff. This will prevent using an invalid length for skb_put
> which would cause a skb panic inside the driver.

Applied, thanks for the patch!

 Jiri

-- 
Jiri Benc
SUSE Labs
