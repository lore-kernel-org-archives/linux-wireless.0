Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.230]:10822 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbXKWTeT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 14:34:19 -0500
Received: by nz-out-0506.google.com with SMTP id s18so2566542nze
        for <linux-wireless@vger.kernel.org>; Fri, 23 Nov 2007 11:34:17 -0800 (PST)
Message-ID: <8e6f94720711231134t66bc0bcbt9651297221cca56b@mail.gmail.com> (sfid-20071123_193422_638906_53E8FC4A)
Date: Fri, 23 Nov 2007 14:34:17 -0500
From: "Will Dyson" <will.dyson@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: mac80211 regression: doesn't associate automatically
Cc: "Holger Schurig" <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1195822116.4149.116.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200711220912.10452.hs4233@mail.mn-solutions.de>
	 <200711221605.55506.hs4233@mail.mn-solutions.de>
	 <1195746110.4149.23.camel@johannes.berg>
	 <200711221719.40412.hs4233@mail.mn-solutions.de>
	 <8e6f94720711221232p16b90daaya5fe3550729b49c8@mail.gmail.com>
	 <1195822116.4149.116.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 23, 2007 7:48 AM, Johannes Berg <johannes@sipsolutions.net> wrote:

> I don't think this can work because when say wpa_supplicant changes the
> key the last thing we want is to have that cause a reconsideration of
> which AP we're associated with. Or even a disassoc/reassoc cycle.

Ah, yes dynamic WEP (or does wpa also go through those ioctls?). Thanks.

-- 
Will Dyson
