Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33144 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333AbbBWQH3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 11:07:29 -0500
Message-ID: <1424707639.3075.18.camel@sipsolutions.net> (sfid-20150223_170736_280017_8037998D)
Subject: Re: [PATCH] nl80211: add new scan flag to indicate P2P search
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Dedy Lansky <dlansky@codeaurora.org>,
	linux-wireless@vger.kernel.org,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Mon, 23 Feb 2015 17:07:19 +0100
In-Reply-To: <20150126095800.GA12740@w1.fi>
References: <1422189052-25602-1-git-send-email-dlansky@codeaurora.org>
	 <1422260840.1890.9.camel@sipsolutions.net> <20150126095800.GA12740@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-01-26 at 11:58 +0200, Jouni Malinen wrote:

> > If you need to distinguish, you should be able to advertise P2P-Device
> > supports, and then get P2P scans on the P2P-Device virtual interface.
> > Could be a pure driver thing of course.
> 
> It would be unfortunate to force people to use P2P-Device for this.
 
Just for the record - we discussed this in Ottawa and as I understood it
you seemed not to object as much to P2P-Device as here originally.

In particular, we discussed the fact that P2P-Device can share MAC
addresses with the regular interface, but also from a 'foreign'
interface (i.e. a different NIC supporting e.g. different bands).

I'll drop all of this for now, at least until you investigate P2P-Device
support more thoroughly.

johannes

