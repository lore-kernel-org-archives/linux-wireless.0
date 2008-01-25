Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154]:39065 "EHLO
	pne-smtpout4-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753471AbYAYNUc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 08:20:32 -0500
Subject: Re: [PATCH 00/14] RFC: Driver for Wireless RNDIS USB devices.
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: David Brownell <david-b@pacbell.net>
Cc: linux-wireless@vger.kernel.org, bjd@jooz.net,
	netdev@vger.kernel.org
In-Reply-To: <200801241719.14941.david-b@pacbell.net>
References: <20080120001342.25718.83669.stgit@fate.lan>
	 <200801241719.14941.david-b@pacbell.net>
Content-Type: text/plain
Date: Fri, 25 Jan 2008 15:20:24 +0200
Message-Id: <1201267224.7266.6.camel@localhost> (sfid-20080125_132038_946897_D9E5C651)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-01-24 at 17:19 -0800, David Brownell wrote:
> > 13. [rndis_host] blacklist known wireless RNDIS devices
> 
> That will be a headache over time though ... can't you just
> let the probe succeed enough to recogize it's wireless (using
> the media flag) and then bail, so the next driver can try?

Sure, that works too (but causes a little bit more message flood).


