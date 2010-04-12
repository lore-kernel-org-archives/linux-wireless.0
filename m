Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:64683 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659Ab0DLSE0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 14:04:26 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 12 Apr 2010 11:04:26 -0700
Date: Mon, 12 Apr 2010 11:04:24 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Anton Puolakka <Anton.Puolakka@7signal.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: Survey mode volunteers
Message-ID: <20100412180424.GB2920@tux>
References: <0290AB2F0A8E124B9FFC144088A1A95609D6029647@EX-MBS04.nbl.local>
 <20100401163526.GB2483@tux>
 <0290AB2F0A8E124B9FFC144088A1A95609D6096AB9@EX-MBS04.nbl.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <0290AB2F0A8E124B9FFC144088A1A95609D6096AB9@EX-MBS04.nbl.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 09, 2010 at 06:58:06AM -0700, Anton Puolakka wrote:
> 
> Hello,
> 
> 
> File nl80211.c contains function nl80211_dump_survey(...)
> but as soon as the relevant input parameter checks are done, we soon encounter EOPNOTSUPPORTED. The support would be more than welcomed so we are investigating the option to participate to the development.
> 

> So, the possible futures of supporting this network link layer dump_survey functionality in ath9k could be one of the following:
> 
> 1. shall never be there
> 2. we do not know yet, we should think about the design at some point
> 3. should be there but we've been busy enough with other stuff

This is the case, if someone gets to it, that would be great. Please
use the linux-wireless list moving forward.

  Luis
