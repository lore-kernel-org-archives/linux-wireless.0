Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45453 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab0CCOAj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 09:00:39 -0500
Date: Wed, 3 Mar 2010 08:48:57 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/7] ath9k: Add common code to lib
Message-ID: <20100303134856.GB23920@tuxdriver.com>
References: <19339.35501.467215.380773@gargle.gargle.HOWL> <19340.54345.580466.373621@gargle.gargle.HOWL> <20100303005220.GJ8069@bombadil.infradead.org> <19341.56441.523682.509267@gargle.gargle.HOWL> <43e72e891003022017l73226794kd3856f2d9ca0ae2@mail.gmail.com> <19341.62966.393227.239280@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <19341.62966.393227.239280@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 03, 2010 at 11:09:02AM +0530, Sujith wrote:
> Luis R. Rodriguez wrote:
> > Ah thanks. So why remove a library at the end if the driver hasn't
> > been merged yet, how about just do away with the library from the
> > start and add the stuff you need to ath9k_htc on the first patch.
> 
> Ok.
> 
> John, can you just drop everything ?
> I (or someone) will send fresh patches after we fix this mess.

Sure.

> I know you are probably seething with irritation now, but remember,
> I might save the world someday and you might not be on the hero's side ...

I may seem scratchy on the list, but I usually save the seething for
when I am attacked personally. :-)

Be ready, hero!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
