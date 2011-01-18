Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35804 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab1ARPjn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 10:39:43 -0500
Subject: Re: intermittent eap authentication failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Chuck Crisler <ccrisler@vgocom.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <8D410FA49EFD4D8997BAC548BA2D55AF@ChuckPC>
References: <D323CFEF4DEC4E18AFF56742F78C16B6@ChuckPC>
	 <1295347932.3563.13.camel@jlt3.sipsolutions.net>
	 <BB274B92115347F9A8E250DEF0C2B732@ChuckPC>
	 <1F9D19D1999A4D7885D0A4DD7BEBCEE8@ChuckPC>
	 <1295362622.3563.23.camel@jlt3.sipsolutions.net>
	 <48A27D1459A9493C8A16D0D6308A5FB1@ChuckPC>
	 <1295364238.3563.24.camel@jlt3.sipsolutions.net>
	 <8D410FA49EFD4D8997BAC548BA2D55AF@ChuckPC>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 16:39:41 +0100
Message-ID: <1295365181.3563.25.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-18 at 10:33 -0500, Chuck Crisler wrote:
> The deauth reason code isn't passed up to the supplicant, 

With -Dnl80211 it should be, no?

johannes

