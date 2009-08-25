Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:49008 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755662AbZHYUaz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 16:30:55 -0400
Subject: Re: [PATCH 2.6.31] ath5k: temporarily disable crypto for AP mode
From: Pavel Roskin <proski@gnu.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090714015739.GA28490@hash.localnet>
References: <20090714015739.GA28490@hash.localnet>
Content-Type: text/plain
Date: Tue, 25 Aug 2009 16:30:52 -0400
Message-Id: <1251232252.9398.2.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-07-13 at 21:57 -0400, Bob Copeland wrote:
> Pavel Roskin reported some issues with using AP mode without
> nohwcrypt=1.  Most likely this is similar to the problem fixed
> some time ago in ath9k by 3f53dd64f192450cb331c0fecfc26ca952fb242f,
> "ath9k: Fix hw crypto configuration for TKIP in AP mode."
> 
> That only affects TKIP but it's easiest to just disable that and
> WEP too until we get a proper fix in.
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
> 
> Pavel, this ok with you for now?

Sorry for delay.  I don't have time to test it, but I have no specific
objections.

-- 
Regards,
Pavel Roskin
