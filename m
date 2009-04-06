Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47175 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbZDFSPs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Apr 2009 14:15:48 -0400
Date: Mon, 6 Apr 2009 14:00:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Michael Buesch <mb@bu3sch.de>,
	Jaswinder Singh Rajput <jaswinder@kernel.org>,
	Sujith <Sujith.Manoharan@atheros.com>,
	wireless <linux-wireless@vger.kernel.org>,
	David Miller <davem@davemloft.net>,
	LKML <linux-kernel@vger.kernel.org>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: ath9k becon loss messages
Message-ID: <20090406180042.GD10842@tuxdriver.com> (sfid-20090406_201552_235553_A570EAF9)
References: <1238923439.4120.9.camel@localhost.localdomain> <200904061217.31134.mb@bu3sch.de> <87tz52xepy.fsf@litku.valot.fi> <200904061251.10965.helmut.schaa@gmail.com> <da94abde0904060405k280b3094jc20d0f7a4e6e759d@mail.gmail.com> <87iqlhdd3z.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87iqlhdd3z.fsf@litku.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 06, 2009 at 06:18:56PM +0300, Kalle Valo wrote:

> When I'm able to implement the proper fix, I think it should first have
> proper testing in wireles-testing before pushing it to mainline. So
> maybe the proper fix is 2.6.31 material, just to be on the safe side
> here.
> 
> John, what do you think?

It depends on what the proper fix looks like, but basically anything
posted in the last week and thereafter is already 2.6.31 material
unless it is a specific bug fix for what is already in Linus' kernel.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
