Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([193.35.52.29]:39326 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaH3AYX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2014 20:24:23 -0400
Date: Sat, 30 Aug 2014 02:24:18 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Support DTPC IE (from Cisco Client eXtensions)
Message-ID: <20140830002418.GA20725@sesse.net> (sfid-20140830_022427_457105_B5538F2F)
References: <20140824103728.GA2938@sesse.net>
 <E1XLZxt-0002h9-Um@pannekake.samfundet.no>
 <1409211818.2505.12.camel@jlt4.sipsolutions.net>
 <20140828083738.GA19530@sesse.net>
 <20140829081902.GB21763@sesse.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20140829081902.GB21763@sesse.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 29, 2014 at 10:19:02AM +0200, Steinar H. Gunderson wrote:
> I'll be sending a patch later today.

...and of course, in the refactoring, I removed the part that actually sets
sdata->ap_power_level, so my new patch series is borked, too. I'll fix,
do some more testing, and then send a new patch series.

Feedback on the general structure is very welcome, though!

/* Steinar */
-- 
Homepage: http://www.sesse.net/
