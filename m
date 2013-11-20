Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hetz2.bluebottle.com ([176.9.57.138]:60030 "EHLO
	fe0.bluebottle.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755157Ab3KTUuB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 15:50:01 -0500
Date: Wed, 20 Nov 2013 21:57:38 +0100
From: Bastian Bittorf <bittorf@bluebottle.com>
To: OpenWrt Development List <openwrt-devel@lists.openwrt.org>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Marek Lindner <lindner_marek@yahoo.de>, sven@narfation.org
Subject: Re: [OpenWrt-Devel] AR9330 hornet board stops beaconing after a few
 days (0xdeadbeef)
Message-ID: <20131120205738.GM886@medion.lan> (sfid-20131120_215006_275260_E1B60326)
References: <20120813165340.GA10044@pandem0nium>
 <20120819220436.GA9899@pandem0nium>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120819220436.GA9899@pandem0nium>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de> [19.09.2012 11:25]:
> just to bump again - isn't there anyone who can give us some hint or
> clue regarding these 0xdeadbeef entries in the registers? Couldn't find
> a connection to other reports deadbeef on the mailing list so far.

it doesnt make sense to debug such an old firmware (r31729).
first upgrade to trunk (~r38885), then report again. bye, bastian
