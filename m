Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41472 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaKFNPT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 08:15:19 -0500
Message-ID: <1415279690.17015.7.camel@sipsolutions.net> (sfid-20141106_141523_734255_8E206CA2)
Subject: Re: [PATCH] mac80211: Fix regression that triggers a kernel BUG
 with CCMP
From: Johannes Berg <johannes@sipsolutions.net>
To: Ronald Wahl <ronald.wahl@raritan.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@googlemail.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu, 06 Nov 2014 14:14:50 +0100
In-Reply-To: <545B7290.6060409@raritan.com>
References: <1415267752-4704-1-git-send-email-ronald.wahl@raritan.com>
		 <1415268135.1884.1.camel@sipsolutions.net> <545B6AD3.8020301@broadcom.com>
	 <1415277562.17015.4.camel@sipsolutions.net> <545B7290.6060409@raritan.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-11-06 at 14:07 +0100, Ronald Wahl wrote:

> But there are LTS kernels not maintained by Greg like 3.12 and 3.16. How 
> about these? If sending patches to stable@kernel org is optional then 
> it's better to kill that list or silently drop emails send to this list 
> so no errors are returned for this address.

They can pick it up the same way though, no? Actually I think they
usually pick it up from Greg's tree anyway :)

johannes

