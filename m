Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:43642 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756631AbZLWS01 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 13:26:27 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH][resend with linux-wireless] b43: N-PHY: clean table init, check PHY rev
Date: Wed, 23 Dec 2009 19:26:14 +0100
Cc: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <b170af450912230401l7a27b981o42cdbc96e5a16b57@mail.gmail.com> <4B325F27.4020506@lwfinger.net>
In-Reply-To: <4B325F27.4020506@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200912231926.17206.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 23 December 2009 19:19:19 Larry Finger wrote:
> ACK for the relocation of the tables.

Well, the _tables_ aren't actually relocated with that patch. The tables
are already in the tables_nphy.c file. You just relocate the functions that upload
the tables.
So if you want to relocate the upload-functions, the question arises whether
the tables should be made static.

-- 
Greetings, Michael.
