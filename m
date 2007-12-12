Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:37056 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbXLLEj7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2007 23:39:59 -0500
Message-ID: <59117.84.58.189.94.1197434396.squirrel@webmail.madwifi.org> (sfid-20071212_044007_214401_E3F42BE8)
In-Reply-To: <BAY134-W251B269AE3F727106D931FD4640@phx.gbl>
References: <BAY134-W251B269AE3F727106D931FD4640@phx.gbl>
Date: Wed, 12 Dec 2007 05:39:56 +0100 (CET)
Subject: Re: Misleading PCI id information on chipsets supported by ath5k
From: "Michael Renzmann" <mrenzmann@madwifi.org>
To: "Joachim Frieben" <jfrieben@hotmail.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

> In particular, the following entry is incorrect:
>
> Vendor:device   Type       Basic-testing
> 168c:0013      AR5212   OK

At least for Atheros cards PCI IDs are not reliable to determine the
chipset that is used on the cards. While it worked in the past, several
vendors started to ship cards with AR5007 chipset but used the AR5006 PCI
ID for them.

If at all, PCI IDs can be seen as evidence but should not be regarded
authoritative in terms of chipset identification. ath_info does a better
job here.

Bye, Mike
