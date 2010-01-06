Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:48758 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932558Ab0AFSXB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 13:23:01 -0500
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: [PATCH 2/5] b43: N-PHY: b43_nphy_get_tx_gains
Date: Wed, 6 Jan 2010 19:22:56 +0100
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
References: <op.u54a59c89lhzdc@linux-g0th.site> <43e72e891001060926s320bf403ya2edf2601ced5125@mail.gmail.com> <b170af451001061018x6ff2404ajbdbb3cb96ceaf7f2@mail.gmail.com>
In-Reply-To: <b170af451001061018x6ff2404ajbdbb3cb96ceaf7f2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001061922.58203.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 06 January 2010 19:18:39 Rafał Miłecki wrote:
> > Dude what is up with this e-mail data on your patches in the commit log?
> 
> That is way of encoding non-ASCII chars in mail header. You can find
> info about this in RFC. That is "=?UTF-8?B?" prefix and base 64
> encoded text.
> 
> That was generated with git (git format-patch -5) and it understood by
> git (git am ...).

Well, however, there is no reason to include this in the mail body (and thus
the GIT commit message).
As you said, these are mail _headers_.
Additionally, attaching the patch as mail attachment is _not_ required. We just
put the patch into the body.

You may read Documentation/SubmittingPatches and format your future
patches according to that.

-- 
Greetings, Michael.
