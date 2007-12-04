Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:16488 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbXLDUea convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 15:34:30 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] libertas: implement new scanning logic
Date: Tue, 4 Dec 2007 21:34:52 +0100
References: <200711290927.15915.hs4233@mail.mn-solutions.de> <1196787130.4772.2.camel@localhost.localdomain>
In-Reply-To: <1196787130.4772.2.camel@localhost.localdomain>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Message-Id: <200712042134.53084.hs4233@mail.mn-solutions.de> (sfid-20071204_203435_673808_B8B446B3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> So I tested this one, not the one from libertas-dev (which was posted
> a day earlier).  And this one seems fine.  Ack for commit to
> libertas-2.6.

Hmm, for the patch you just "acked" inofficially is already older.
I know at least two changes that I made since then:

* add a comment to the section where I change the basic rates by
  setting the high bit (your idea)

* adapt to the patch "ibertas: separate mesh connectivity from that
  of the main interface" that appeared in wireless-2.6/everything

Please note that my current patch doesn't apply anymore to 
wireless-2.6/everything (a.k.a wl26e). It might still apply to 
libertas-2.6, because this tree lacked (four hours ago) at least 4 
patches that are in wl26e.

>From the 40 mails about git, commits, patches, rebases etc I was not 
able to draw a real conclusion. I'm tending towards basing my patches 
against wl26e, so that John, Jeff etc can push the patches easily up. 
And if a patch still applies, I can commit/push the patch once you 
acked them. If the patch doesn't apply there, I'll post about this face 
in libertas-dev. I hope that helps all sides the most.


> Would you like me to confirm on SDIO?

Yes, please. I think the patch is hardware agnistic, but you can
never know because SDIO firmware != CF firmware != USB firmware.
