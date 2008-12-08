Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout2-sn1.fre.skanova.net ([81.228.11.159]:47008 "EHLO
	pne-smtpout2-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751886AbYLHQ2g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 11:28:36 -0500
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: "'Johannes Berg'" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: RE: Monitor number of packages sent and ACK'ed by AP
Date: Mon, 8 Dec 2008 17:28:14 +0100
Message-ID: <2302AE261F8F40829ECF8CCCB6DD612B@gotws1589> (sfid-20081208_172841_371568_E610419C)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
In-Reply-To: <1228741319.22164.80.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> On Mon, 2008-12-08 at 11:50 +0100, Lars Ericsson wrote:
> > Hi Johannes,
> > 
> > I would like to monitor number of packages properly 
> transmitted and ACK'ed
> > by the AP.
> > Is the a single point where this can be done ?
> 
> Not really, some drivers don't even give you that information,
> unfortunately.
> 
> johannes
> 

OK, thanks. 
I just discovered that Ralink rt61 does filter all ACK frames.
/Lars

