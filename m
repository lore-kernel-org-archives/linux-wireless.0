Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33460 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab0A0Tpg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2010 14:45:36 -0500
Date: Wed, 27 Jan 2010 14:31:55 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: zajec5@gmail.com, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: N PHY: Fix compilation after removal of typdef
	b43_c32
Message-ID: <20100127193155.GH2962@tuxdriver.com>
References: <4b5f6fba.foXrkAD8gU11wYBv%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4b5f6fba.foXrkAD8gU11wYBv%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 26, 2010 at 04:42:02PM -0600, Larry Finger wrote:
> In the conversion between typedef and struct, two places that needed a "struct"
> were missed.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> John,
> 
> Without these, compilation fails.
> 
> Larry

Larry, thanks for fixing this!  Sorry I missed those bits.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
