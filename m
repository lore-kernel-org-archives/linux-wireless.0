Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:5305 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbXKVP5e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 10:57:34 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211 regression: doesn't associate automatically
Date: Thu, 22 Nov 2007 16:58:02 +0100
Cc: linux-wireless@vger.kernel.org
References: <200711220912.10452.hs4233@mail.mn-solutions.de> <1195746110.4149.23.camel@johannes.berg> <1195746399.4149.26.camel@johannes.berg>
In-Reply-To: <1195746399.4149.26.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200711221658.02233.hs4233@mail.mn-solutions.de> (sfid-20071122_155745_040263_1497750A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> In fact, the *ONLY* think wext defines (via iwconfig's man
> page) is that setting an AP mac address forces association.
> Everything else is being nice. Hence, to be absolutely
> compatible you should *always* issue "iwconfig <dev> ap any"
> after setting configuration.

What you describe is the law, but not the life. Get a grip. It 
starts to be comical.

In real life, "iwconfig XXX AP YYY" is VERY seldom used. For a 
start, it would disable roaming.
