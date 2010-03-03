Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36140 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab0CCFTz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 00:19:55 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 02 Mar 2010 21:19:55 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19341.62966.393227.239280@gargle.gargle.HOWL>
Date: Wed, 3 Mar 2010 11:09:02 +0530
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/7] ath9k: Add common code to lib
In-Reply-To: <43e72e891003022017l73226794kd3856f2d9ca0ae2@mail.gmail.com>
References: <19339.35501.467215.380773@gargle.gargle.HOWL>
	<19340.54345.580466.373621@gargle.gargle.HOWL>
	<20100303005220.GJ8069@bombadil.infradead.org>
	<19341.56441.523682.509267@gargle.gargle.HOWL>
	<43e72e891003022017l73226794kd3856f2d9ca0ae2@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> Ah thanks. So why remove a library at the end if the driver hasn't
> been merged yet, how about just do away with the library from the
> start and add the stuff you need to ath9k_htc on the first patch.

Ok.

John, can you just drop everything ?
I (or someone) will send fresh patches after we fix this mess.

I know you are probably seething with irritation now, but remember,
I might save the world someday and you might not be on the hero's side ...

Sujith
