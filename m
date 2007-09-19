Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2970 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbXISVll (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 17:41:41 -0400
Date: Wed, 19 Sep 2007 17:26:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: hch@infradead.org, jeff@garzik.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, flamingice@sourmilk.net
Subject: Re: Please pull 'p54' branch of wireless-2.6
Message-ID: <20070919212607.GA3036@tuxdriver.com>
References: <20070919195527.GD5483@tuxdriver.com> <20070919210405.GA2231@infradead.org> <20070919.141200.56568833.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070919.141200.56568833.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 19, 2007 at 02:12:00PM -0700, David Miller wrote:
> From: Christoph Hellwig <hch@infradead.org>
> Date: Wed, 19 Sep 2007 22:04:05 +0100
> 
> > PLease put it into a separate subdirectory, thanks.
> > 
> > Also net2280.h seems rather oddly named.
> 
> The next time I rebase I'll try to take care of this for both
> this driver and the iwlwifi stuff.

Fine by me, although I swear I remember complaints about adding separate
directories for drivers...*shrug*...

John
-- 
John W. Linville
linville@tuxdriver.com
