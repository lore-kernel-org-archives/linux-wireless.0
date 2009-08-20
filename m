Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51743 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433AbZHTPAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 11:00:12 -0400
Date: Thu, 20 Aug 2009 10:52:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: gregor kowski <gregor.kowski@gmail.com>
Cc: bcm43xx-dev@lists.berlios.de, Michael Buesch <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org
Subject: Re: [RESEND] [PATCH] b43 : remove old kidx API
Message-ID: <20090820145213.GB2657@tuxdriver.com>
References: <83a869cd0907271343g6111794ejff963258a52f546@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <83a869cd0907271343g6111794ejff963258a52f546@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 27, 2009 at 10:43:36PM +0200, gregor kowski wrote:
> Remove old kidx API.
> This simplify the code, and fix a potential key overflow.
> 
> Signed-off-by: Gregor Kowski <gregor.kowski@gmail.com>

Is this patch still relevant?  If so, could you repost a version that
isn't whitespace damaged and that actually applies?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
