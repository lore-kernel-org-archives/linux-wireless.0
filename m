Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33283 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbcHAJQF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2016 05:16:05 -0400
Message-ID: <1470042961.3389.6.camel@sipsolutions.net> (sfid-20160801_111609_060141_8DADCA7C)
Subject: Re: rfkill bound to a switch
From: Johannes Berg <johannes@sipsolutions.net>
To: Kai Hendry <hendry@iki.fi>, linux-wireless@vger.kernel.org
Date: Mon, 01 Aug 2016 11:16:01 +0200
In-Reply-To: <1469692952.331455.679081257.3C81B1F3@webmail.messagingengine.com> (sfid-20160728_100238_835650_2A9D839C)
References: <1469692952.331455.679081257.3C81B1F3@webmail.messagingengine.com>
	 (sfid-20160728_100238_835650_2A9D839C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-07-28 at 16:02 +0800, Kai Hendry wrote:
> Hi there,
> 
> Since laptops typically have a toggle button for killing and enabled
> wifi, how does one supposed to bind rfkill like a toggle?
> 
> I.e. knowing which state you are in so you can call {block,unblock}
> accordingly?
> 
> Parsing event or list output seems non-trivial.
> 

Don't use the rfkill tool - just open /dev/rfkill yourself, the API is
really simple.

johannes
