Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:12776 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567AbXK2Jbb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2007 04:31:31 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] less eventcause shifts
Date: Thu, 29 Nov 2007 10:32:27 +0100
Cc: David Woodhouse <dwmw2@infradead.org>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
References: <200711280915.11300.hs4233@mail.mn-solutions.de> <200711281613.51463.hs4233@mail.mn-solutions.de> <1196267365.30806.40.camel@pmac.infradead.org>
In-Reply-To: <1196267365.30806.40.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711291032.27679.hs4233@mail.mn-solutions.de> (sfid-20071129_093135_359486_AACBA68F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Let me have a SSH public key and I'll give you an account with
> access to that tree.

You have it already. I actually once put my patches into a git 
tree, but no one pulled from it (neither Dan nor Linville), so I 
stopped the extra work.

My username at git.infradead.org (a.k.a. bombadil) is "schurig".

However, wireless-2.6/everything is now 8 days old. Shouldn't we 
prod Linville a bit more?



> > In what parts of libertas are you working?

> Rewriting the command submission and queueing code.

Cool.


> I could do with getting hold of SD and CF devices -- any hints
> on where to find them?

About the SD card: ask "ossmann" on #libertas on freenode.net.

For the CF card: Ambicom WL54CF. However, I've got mine from some 
company in Germany (which name I forgot ...).
