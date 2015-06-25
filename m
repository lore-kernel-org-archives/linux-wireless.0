Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37631 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbbFYSK5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Jun 2015 14:10:57 -0400
Message-ID: <1435255854.2096.18.camel@sipsolutions.net> (sfid-20150625_201108_596462_9F5E9712)
Subject: Re: iw and non-ASCII SSIDs
From: Johannes Berg <johannes@sipsolutions.net>
To: Joerg <pommnitz@yahoo.com>, linux-wireless@vger.kernel.org
Date: Thu, 25 Jun 2015 20:10:54 +0200
In-Reply-To: <loom.20150625T181029-814@post.gmane.org> (sfid-20150625_181310_521075_380CF492)
References: <loom.20150625T181029-814@post.gmane.org>
	 (sfid-20150625_181310_521075_380CF492)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-06-25 at 16:12 +0000, Joerg wrote:
> Hello all,
> is there a way to submit a non-ASCII SSID with iw? One that contains 
> 0 as in an octet with value zero?

No, that doesn't seem to be possible in the code.

But it's certainly possible in wp_supplicant config file, which you
should probably be using anyway?

johannes
