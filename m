Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:41298 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab3JXDeb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Oct 2013 23:34:31 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21096.37952.314117.902275@gargle.gargle.HOWL> (sfid-20131024_053434_615915_42A50517)
Date: Thu, 24 Oct 2013 09:00:08 +0530
To: Karl Beldan <karl.beldan@gmail.com>
Cc: voncken <cedric.voncken@acksys.fr>,
	'John Linville' <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: Identify Killer Wireless cards
In-Reply-To: <20131023164653.GA22500@magnum.frso.rivierawaves.com>
References: <1382519771-11170-1-git-send-email-sujith@msujith.org>
	<014d01cecff7$ce744080$6b5cc180$@acksys.fr>
	<21095.58324.375248.315193@gargle.gargle.HOWL>
	<20131023164653.GA22500@magnum.frso.rivierawaves.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Karl Beldan wrote:
> > http://www.killergaming.com/solutions/Wireless
> > http://www.qca.qualcomm.com/networking/feature.php?feature=32
> > 
> Jokes apart, the links do not give much technical information ..

These cards are meant for low-latency situations, primarily gaming.
I am still trying to find out if there are any HW quirks to be handled
in the driver, but they seem to just work with ath9k.

The 3x3 card is based on AR9380 and the 2x2 card is based on AR9462.

Sujith
