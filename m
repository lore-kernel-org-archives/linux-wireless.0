Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([193.35.52.29]:58262 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbaIGRCV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Sep 2014 13:02:21 -0400
Received: from pannekake.samfundet.no ([2001:67c:29f4::50] ident=unknown)
	by cassarossa.samfundet.no with esmtps (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <sesse@samfundet.no>)
	id 1XQfr0-0002S7-Fd
	for linux-wireless@vger.kernel.org; Sun, 07 Sep 2014 19:02:18 +0200
Received: from sesse by pannekake.samfundet.no with local (Exim 4.80)
	(envelope-from <sesse@samfundet.no>)
	id 1XQfr0-000217-0Z
	for linux-wireless@vger.kernel.org; Sun, 07 Sep 2014 19:02:18 +0200
Date: Sun, 7 Sep 2014 19:02:18 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5 2/2] mac80211: support DTPC IE (from Cisco Client
 eXtensions)
Message-ID: <20140907170217.GA6706@sesse.net> (sfid-20140907_190224_937088_1A37299B)
References: <20140830184516.GA31497@sesse.net>
 <E1XONJB-0005LB-O8@pannekake.samfundet.no>
 <1409745636.911.13.camel@jlt4.sipsolutions.net>
 <20140903133328.GC18933@sesse.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20140903133328.GC18933@sesse.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 03, 2014 at 03:33:28PM +0200, Steinar H. Gunderson wrote:
> I'm in a hotel room in Seattle right now whose Wi-Fi is not Cisco-based,
> so I can't test the new version as thoroughly as I'd like, but I'll at least
> give it a boot test and then send an updated patch series as reply to this
> message.

It seems the airport in Seattle has Cisco-based Wi-Fi, so while waiting on
the plane to take me on, I got:

  wlan0: Limiting TX power to 23 dBm as advertised by 50:06:04:bb:d2:de

In other words, v6 still appears to work fine in practical testing. :-)

/* Steinar */
-- 
Homepage: http://www.sesse.net/
