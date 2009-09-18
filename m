Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:21055 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662AbZIRAGl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 20:06:41 -0400
Received: by qw-out-2122.google.com with SMTP id 5so204531qwd.37
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2009 17:06:44 -0700 (PDT)
Subject: Re: regression?  No connection with master-2009-09-16 was fine
 until master-2009-09-14
From: ASIC Felix <ic.felix@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1253230530.23567.1.camel@johannes.local>
References: <1253208348.6601.17.camel@darkslate>
	 <1253230530.23567.1.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 17 Sep 2009 17:05:19 -0700
Message-Id: <1253232319.6914.15.camel@darkslate>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-09-17 at 16:35 -0700, Johannes Berg wrote:
> On Thu, 2009-09-17 at 10:25 -0700, ASIC Felix wrote:
> 
> > ath9k: Two wiphys trying to scan at the same time
> 
> how about you stop playing with multi-wiphy things _first_?

How can I disable it? (sorry)

> and then describe your setup ... the patch works fine here and Holger
> said it fixed his problem. hidden ssid by any chance?

Office network, can see about 50 APs, more 2G than 5G.

Main office ssid is available on most 2G channels 11g (no 11n), also on
several 5G channels 11a (no 11n). Lots of other ssids are visible.
WPA2/PSK.

H/W: IBM Thinkpad T43.
wifi: phy0: Atheros AR9280 MAC/BB Rev:2 AR5133 RF Rev:d0:
mem=0xf9ca0000, irq=21

Distro:	Mandriva 2009.1
Kernel:
git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
(no patches added)

Will try on home network too, haven't done that yet.

Best regards,
Felix

