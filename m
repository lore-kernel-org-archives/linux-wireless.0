Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:28763 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbZJVHNn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 03:13:43 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: allow driver to signal noise level
Date: Thu, 22 Oct 2009 09:13:19 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <200910201413.29734.hs4233@mail.mn-solutions.de> <1256080691.4475.8.camel@johannes.local>
In-Reply-To: <1256080691.4475.8.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200910220913.19759.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 21 October 2009 01:18:11 Johannes Berg wrote:
> As discussed previously, noise is not a property of a station.

URL?


Should I aim for an "iw dev XXX show noise", e.g. try to
handle it as a property of the card?  I could either add
an .get_noise() to cfg80211_ops, or better an .get_card_status()
with some bitmask of filled fields, like for the .get_station()
call. What would you prefer?

-- 
http://www.holgerschurig.de
