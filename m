Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:55890 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932385Ab0AFThT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 14:37:19 -0500
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: [PATCH 2/5] b43: N-PHY: b43_nphy_get_tx_gains
Date: Wed, 6 Jan 2010 20:36:53 +0100
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
References: <op.u54a59c89lhzdc@linux-g0th.site> <201001061922.58203.mb@bu3sch.de> <b170af451001061129n59357edehc1f2328fb10846f6@mail.gmail.com>
In-Reply-To: <b170af451001061129n59357edehc1f2328fb10846f6@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201001062036.55758.mb@bu3sch.de>
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 06 January 2010 20:29:36 Rafał Miłecki wrote:
> > You may read Documentation/SubmittingPatches and format your future
> > patches according to that.
> 
> Well, that's really poor joke :| Manually creating .orig files, using
> "diff -up" and so dropping local commits "strategy"...? Er, I don't
> think I'll use this one.

Nobody said you need to fix your internal workflow. Why would anybody care
_how_ you generate your patches?
You could manually type them into your cellphone with T9. If that it results
in a properly formated patch in the end, nobody would complain.

So yes, reading other people's patches probably is a good idea to start with.

In general only put stuff into the mail that you want to show up in the commit
message. (If you want to have additional stuff that doesn't show up in the commit
message, you can use the "---" delimiter. But that's documented elsewhere so
I don't have to explain that here...)

-- 
Greetings, Michael
