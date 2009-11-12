Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:56529 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599AbZKLSKm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 13:10:42 -0500
Date: Thu, 12 Nov 2009 19:10:45 +0100
From: Johannes Stezenbach <js@sig21.net>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: ath9k: DMA failed to stop in 10 ms
Message-ID: <20091112181045.GA8839@sig21.net>
References: <20091112152600.GA7562@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20091112152600.GA7562@sig21.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 12, 2009 at 04:26:00PM +0100, Johannes Stezenbach wrote:
> 
> When running kismet I get a lot of
> 
> [ 2030.531809] ath9k: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020

Update: It seems that this is only happening when kismet is hopping
channels.  So it looks like an unclean shutdown of the receive
process and not a real problem -- except that the log flooding is
pretty annoying.


Johannes
