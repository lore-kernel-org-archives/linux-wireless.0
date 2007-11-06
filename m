Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:19636 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbXKFMut (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2007 07:50:49 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] move wlan_*_association_work from header to c file
Date: Tue, 6 Nov 2007 13:51:14 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>
References: <200710111151.06989.hs4233@mail.mn-solutions.de> <200710261343.51684.hs4233@mail.mn-solutions.de> <20071106011607.GA23747@tuxdriver.com>
In-Reply-To: <20071106011607.GA23747@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711061351.14673.hs4233@mail.mn-solutions.de> (sfid-20071106_125134_552340_002C629C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> The 2nd patch "libertas: move to uniform lbs_/LBS_ namespace"
> breaks the compile of if_sdio.c, so I had to drop it.  I
> dropped "libertas: clean up association debug messages" as
> well.

I didn't see an if_sdio.c in my tree when I made the patch.

And I wont make a third patch. It's quite discouraging to send 
things which don't get applied (for no known reasons) for more 
than a week. And during that time they bitrot. Would the patch 
have been applied timely, it would have worked in the first 
place.

Also, changing all things wlan_XXX in libertas_XXX is soooo easy. 
However, I won't do it. The one who originally asked for the 
cleanup patch should do the work and have the patience to get 
the patch through, I have real work to do.
