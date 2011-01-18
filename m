Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57546 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab1ARPYA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 10:24:00 -0500
Subject: Re: intermittent eap authentication failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Chuck Crisler <ccrisler@vgocom.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <48A27D1459A9493C8A16D0D6308A5FB1@ChuckPC>
References: <D323CFEF4DEC4E18AFF56742F78C16B6@ChuckPC>
	 <1295347932.3563.13.camel@jlt3.sipsolutions.net>
	 <BB274B92115347F9A8E250DEF0C2B732@ChuckPC>
	 <1F9D19D1999A4D7885D0A4DD7BEBCEE8@ChuckPC>
	 <1295362622.3563.23.camel@jlt3.sipsolutions.net>
	 <48A27D1459A9493C8A16D0D6308A5FB1@ChuckPC>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 16:23:58 +0100
Message-ID: <1295364238.3563.24.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-18 at 10:21 -0500, Chuck Crisler wrote:
> What is the reason that the design calls for a scan in response to a session 
> timeout? A session timeout doesn't happen because of a roam, so the original 
> AP is probably still good. Why scan?

I don't think there's any design here, and in any case that's
wpa_supplicant's doing. :)

johannes

