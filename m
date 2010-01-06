Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:56988 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932671Ab0AFTv4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 14:51:56 -0500
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: [PATCH 2/5] b43: N-PHY: b43_nphy_get_tx_gains
Date: Wed, 6 Jan 2010 20:51:19 +0100
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
References: <op.u54a59c89lhzdc@linux-g0th.site> <201001062036.55758.mb@bu3sch.de> <b170af451001061141l171682aft1130489bd8b7edf5@mail.gmail.com>
In-Reply-To: <b170af451001061141l171682aft1130489bd8b7edf5@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201001062051.20847.mb@bu3sch.de>
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 06 January 2010 20:41:52 Rafał Miłecki wrote:
> I started composing that mail before got real idea of patches. I was
> still thinking I need some magic headers "diff" tool generates. Hope I
> totally understand this now and won't cause more problems to you guys
> :)

There are no problems. It's just a little bit easier for maintainers to merge
properly formatted patches. Importing a properly formatted patch into git is just
a matter of a command or two.

So that said, I think it's awesome that you started to work on the N code.
I hope we get something usable, soon. Lots of people will love you and women
will want to marry you. ;)
Your patches _are_ actually in a pretty good shape. The remaining submission issues
are minor and easy to fix.

-- 
Greetings, Michael.
