Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58077 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbZHXOaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 10:30:12 -0400
Date: Mon, 24 Aug 2009 10:20:09 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: gregor kowski <gregor.kowski@gmail.com>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de, Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCHv4] b43 add harware tkip
Message-ID: <20090824142008.GB8998@tuxdriver.com>
References: <83a869cd0908191335u723f62c6p119ec4ed8cfb51c5@mail.gmail.com> <87eir6tueg.fsf@litku.valot.fi> <83a869cd0908211443s1d366f70o202ae768a93b20dc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <83a869cd0908211443s1d366f70o202ae768a93b20dc@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 21, 2009 at 11:43:55PM +0200, gregor kowski wrote:
> This add hardware tkip for b43. This can help to reduce the load a low
> powered router and make higher throughput. To enable it, you need to
> set "hwtkip" module param.
> 
> Signed-off-by: Gregor Kowski <gregor.kowski@gmail.com>
> Acked-by: Michael Buesch <mb@bu3sch.de>

An earlier version was already merged.  What is different here?

Please submit a new patch with just the differences.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
