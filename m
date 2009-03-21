Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:49757 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbZCUA7r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 20:59:47 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "Alina Friedrichsen" <x-alina@gmx.net>
Subject: Re: [RFC][RFT][PATCH 0/5 v5] ar9170: ar9170 driver (aka mac80211's otus)
Date: Sat, 21 Mar 2009 01:59:44 +0100
Cc: greg@kroah.com, otus-devel@lists.madwifi-project.org,
	linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
References: <200903170408.12626.chunkeey@web.de> <200903202312.57737.chunkeey@web.de> <20090320224920.261010@gmx.net>
In-Reply-To: <20090320224920.261010@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200903210159.44733.chunkeey@web.de> (sfid-20090321_015952_109984_13BF5D81)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 20 March 2009 23:49:20 Alina Friedrichsen wrote:
> > Well, a few features that the vendors uses to encourage potential buyers:
> > - HT ( 802.11n - aka 300mbps )
> 
> Hopefully someone can implement it.

Well, first the rate control algorithm needs to support it ;-).
so there's plenty of time to theorize what to do.

> > - AP/AD-Hoc 
> 
> Ad-Hoc mode with fixed BSSIDs works absolutely fine with this driver. I only didn't find a way to reset the TSF, so that IBSS merges works standard compliant.
> 
> In the praxis all mesh networks uses fixed BSSIDs.
Thanks for confirming!

Regards,
	Chr
