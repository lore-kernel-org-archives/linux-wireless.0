Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34711 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab0JYJKB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 05:10:01 -0400
Subject: Re: Help: Guidance on &quot;AP/VLAN&quot; mode
From: Johannes Berg <johannes@sipsolutions.net>
To: jpo234 <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20101022T132016-729@post.gmane.org>
References: <loom.20101021T172706-705@post.gmane.org>
	 <loom.20101022T132016-729@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Oct 2010 10:50:00 +0200
Message-ID: <1287996600.3587.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-22 at 11:45 +0000, jpo234 wrote:

> I think it's not what you think it is. My understanding is, that this is a
> special AP mode that allows one to bridge traffic through the AP *AND* the
> client. For this to work the 802.11 frames have to carry 4 addresses instead
> of the normal 3. 

Err, no, we just use the AP/VLAN interfaces in 4addr mode for this,
don't get confused :-)

johannes

