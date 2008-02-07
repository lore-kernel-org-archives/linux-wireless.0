Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:46638 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052AbYBGH2Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2008 02:28:16 -0500
Date: Wed, 6 Feb 2008 23:26:24 -0800
From: Greg KH <greg@kroah.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: stable@kernel.org, linux-wireless@vger.kernel.org,
	Bcm43xx-dev@lists.berlios.de
Subject: Re: [stable] [PATCH stable] b43: Reject new firmware early
Message-ID: <20080207072624.GB15657@kroah.com> (sfid-20080207_072818_711442_BEE0655D)
References: <200801261354.52659.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200801261354.52659.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 26, 2008 at 01:54:52PM +0100, Michael Buesch wrote:
> We must reject new incompatible firmware early to avoid
> running into strange transmission failures.
> 
> The current development tree supports newer firmware revisions.
> These revisions cause strange failures on the stable 2.6.24 kernel.
> Add a check to avoid confusing users a lot.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>

Oh wait, I see why it's not in Linus's tree, it doesn't pertain :)

I'll queue this up, sorry for the noise.

greg k-h
