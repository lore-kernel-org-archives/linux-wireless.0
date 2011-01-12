Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43969 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab1ALJDO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 04:03:14 -0500
Subject: Re: Mesh join/leave
From: Johannes Berg <johannes@sipsolutions.net>
To: sbrown@cortland.com
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1294780828.2383.0.camel@mythtv.ewol.com>
References: <1294780828.2383.0.camel@mythtv.ewol.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 10:03:54 +0100
Message-ID: <1294823034.3639.15.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-11 at 16:20 -0500, Steve Brown wrote:
> In testing this, the command "iw mesh0 mesh leave" doesn't stop
> beaconing. Beaconing continues with a null mesh id.
> 
> Is this the intended behavior?

No, it's not -- what driver are you using?

johannes

