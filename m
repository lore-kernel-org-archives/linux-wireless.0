Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42575 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755414AbbBFMCO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 07:02:14 -0500
Message-ID: <1423224126.2037.12.camel@sipsolutions.net> (sfid-20150206_132720_851559_58173008)
Subject: Re: about bitrate information
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 06 Feb 2015 13:02:06 +0100
In-Reply-To: <54D27D90.8030005@broadcom.com>
References: <54D27D90.8030005@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-02-04 at 21:14 +0100, Arend van Spriel wrote:
> Hi Johannes,
> 
> Just a quick question about the bitrate info shown with 'iw link'. I 
> assume the MCS info reported is the MCS related to the bitrate number so 
> the current/last MCS used and not some maximum MCS.

It's a bit dependent on drivers, it can be either the "current best"
bitrate (definitely the case with minstrel) or sometimes just the "last
frame" bitrate which isn't really such a great indicator.

johannes

