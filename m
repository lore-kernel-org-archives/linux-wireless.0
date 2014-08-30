Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([193.35.52.29]:33498 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaH3SpU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Aug 2014 14:45:20 -0400
Received: from pannekake.samfundet.no ([2001:67c:29f4::50] ident=unknown)
	by cassarossa.samfundet.no with esmtps (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <sesse@samfundet.no>)
	id 1XNneG-0001fL-FK
	for linux-wireless@vger.kernel.org; Sat, 30 Aug 2014 20:45:16 +0200
Received: from sesse by pannekake.samfundet.no with local (Exim 4.80)
	(envelope-from <sesse@samfundet.no>)
	id 1XNneG-0008Ts-7O
	for linux-wireless@vger.kernel.org; Sat, 30 Aug 2014 20:45:16 +0200
Date: Sat, 30 Aug 2014 20:45:16 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Support DTPC IE (from Cisco Client eXtensions)
Message-ID: <20140830184516.GA31497@sesse.net> (sfid-20140830_204523_546629_C95B65C4)
References: <20140824103728.GA2938@sesse.net>
 <E1XLZxt-0002h9-Um@pannekake.samfundet.no>
 <1409211818.2505.12.camel@jlt4.sipsolutions.net>
 <20140828083738.GA19530@sesse.net>
 <20140829081902.GB21763@sesse.net>
 <20140830002418.GA20725@sesse.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20140830002418.GA20725@sesse.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 30, 2014 at 02:24:18AM +0200, Steinar H. Gunderson wrote:
> ...and of course, in the refactoring, I removed the part that actually sets
> sdata->ap_power_level, so my new patch series is borked, too. I'll fix,
> do some more testing, and then send a new patch series.

The fix was trivial (just add back the line). I'll be traveling a bit the
next two weeks, so I guess I'll be seeing a few different installations and
see how this pans out. But in my home network, it now looks to be working
very well.

Sending v4 of the patch series as response to this email.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
