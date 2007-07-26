Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3705 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755941AbXGZCfo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 22:35:44 -0400
Date: Wed, 25 Jul 2007 22:19:39 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] Please pull 'upstream' branch of rt2x00
Message-ID: <20070726021939.GA3810@tuxdriver.com>
References: <200707252249.47931.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200707252249.47931.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 25, 2007 at 10:49:47PM +0200, Ivo van Doorn wrote:

> Today a very quick release of 2.0.4,
> reason for this quick followup on 2.0.3 are the fixes
> regarding the USB ID and the rt61pci interrupts.

Ivo,

Thanks for the post -- I merged them into wireless-dev.  You might
also notice that I moved the driver files up two levels into
drivers/net/wireless (along w/ the other drivers).

Any idea when you'll be ready for rt2x00 to go upstream?

John
-- 
John W. Linville
linville@tuxdriver.com
