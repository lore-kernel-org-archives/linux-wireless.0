Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout3-sn1.fre.skanova.net ([81.228.11.120]:36881 "EHLO
	pne-smtpout3-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752115AbYAYNO6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 08:14:58 -0500
Subject: Re: [PATCH 10/14] [rndis_host] Add rndis_early_init function
	pointer to 'struct rndis_data'.
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: David Brownell <david-b@pacbell.net>
Cc: linux-wireless@vger.kernel.org, bjd@jooz.net,
	netdev@vger.kernel.org
In-Reply-To: <200801241710.35528.david-b@pacbell.net>
References: <20080120001438.25718.96722.stgit@fate.lan>
	 <200801241710.35528.david-b@pacbell.net>
Content-Type: text/plain
Date: Fri, 25 Jan 2008 15:14:50 +0200
Message-Id: <1201266890.7266.0.camel@localhost> (sfid-20080125_131504_150586_94C56742)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-01-24 at 17:10 -0800, David Brownell wrote:
> Could this -- and #11/14 -- instead be generalized a bit,
> so they're not RNDIS-specific?  At least in name; the
> only user for now would be the rndis_host code.
> 
> The generalization would presumably be "early_init" and
> "link_change", paired with doc comments reflecting that
> they're usable by any driver stack built over the usbnet
> framework core.
> 
> There's no point IMO to having generalizable hooks be
> restricted this way.

Sure.

