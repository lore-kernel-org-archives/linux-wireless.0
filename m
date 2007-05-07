Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55208 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224AbXEGKlk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2007 06:41:40 -0400
Date: Mon, 7 May 2007 11:41:17 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, marcelo@kvack.org,
	linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: Please pull 'libertas' branch of wireless-2.6
Message-ID: <20070507104117.GA31601@infradead.org>
References: <20070227205649.GH5826@tuxdriver.com> <45E8CF5E.5090305@garzik.org> <20070303052140.GA31075@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070303052140.GA31075@infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 03, 2007 at 05:21:40AM +0000, Christoph Hellwig wrote:
> Umm, I can't remember the updated driver ever beeig posted for review.
> And to be honest I'd be surprised if it's in a good shape already.

Of course it's not anywhere near good shape.  Almost all items from my
review were completely ignored, and we have another totoally substandard
wireless driver with crappy thread handling, a huge number of broken private
ioctls and partially absymal codingstyle.

And I didn't even get a reply to my mail addressing the concerns above.
