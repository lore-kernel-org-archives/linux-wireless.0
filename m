Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36689 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab2IQPCr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2012 11:02:47 -0400
Message-ID: <1347894205.4975.5.camel@jlt4.sipsolutions.net> (sfid-20120917_170250_555799_88C60C4A)
Subject: Re: [PATCH] wireless: remove unreachable code
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 17 Sep 2012 17:03:25 +0200
In-Reply-To: <20120917105354.30097.45595.stgit@localhost.localdomain>
References: <20120917105354.30097.45595.stgit@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-09-17 at 11:54 +0100, Alan Cox wrote:
> From: Alan Cox <alan@linux.intel.com>
> 
> The only case where intersected_rd can become non NULL is within an if. All
> paths from that if return, so the end chunk has therefore squawked its
> last and is no more.

Ohh, a BUG_ON() gone, that makes me happy :-)

Applied, thanks.

johannes

