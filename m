Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:36401 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759270Ab1CDQtN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 11:49:13 -0500
Subject: Re: Powersave broken on p54
From: Michael Buesch <mb@bu3sch.de>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: kvalo@adurom.com, Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <201103021918.30528.chunkeey@googlemail.com> (sfid-20110302_191848_281080_21A09A7E)
References: <1299003142.6461.12.camel@maggie>
	 <201103021813.52719.chunkeey@googlemail.com>
	 <1299086257.13604.17.camel@marge>
	 <201103021918.30528.chunkeey@googlemail.com>
	 (sfid-20110302_191848_281080_21A09A7E)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 17:49:04 +0100
Message-ID: <1299257344.21644.15.camel@marge>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-03-02 at 19:18 +0100, Christian Lamparter wrote:
> > What change to the eeprom is needed? My eeprom doesn't
> > contain any rssi info (see recent NULL ptr fix).
> 
> I think you should (re-)add it, I don't know what the
> firmware is doing with it, but maybe Kalle knows more?
> 
> see "p54spi: update sample eeprom"
> 6c1cef43fb9d4979f9f7e0dcc71f61921730149b

Thanks for the hint. I added that stuff to the
CAL to p54 eeprom converter tool.

-- 
Greetings, Michael.

