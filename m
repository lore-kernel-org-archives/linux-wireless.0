Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53162 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab1AOAzs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 19:55:48 -0500
Received: by gwj20 with SMTP id 20so1332341gwj.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Jan 2011 16:55:45 -0800 (PST)
Subject: Re: [ath9k-devel] [RFC 1/2] ath9k: Fix up hardware mode and
 beacons with multiple vifs.
From: Steve Brown <sbrown@cortland.com>
Reply-To: sbrown@cortland.com
To: =?ISO-8859-1?Q?Bj=F6rn?= Smedman <bjorn.smedman@venatech.se>
Cc: greearb@candelatech.com, ath9k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTi=WTUiy1DYNhE12_KZp8QFUrWebY2Cpzud5P0b3@mail.gmail.com>
References: <1295026029-21130-1-git-send-email-greearb@candelatech.com>
	 <AANLkTi=WTUiy1DYNhE12_KZp8QFUrWebY2Cpzud5P0b3@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Jan 2011 19:55:36 -0500
Message-ID: <1295052936.2253.5.camel@mythtv.ewol.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-01-15 at 00:19 +0100, Björn Smedman wrote:

> Thank you for your efforts to get multi-vifs working better.
> 
> This is another comment that is a little out of place but when I see
> the identifier beacon_interval in this context I cannot help bringing
> up per-vif settings as a related problem: If I read the code (or
> rather the lack of code) correctly the beacon interval of the last (or
> first?) beaconing vif added will be used to set up beacon tx, whereas
> the actual beacon contents will reflect the beacon intervals
> configured for individual vifs which may all be different... The same
> goes for e.g. tx queue configuration, no?
> 
> It feels like we need a general multi-vif cleanup here but it's too
> big for me unfortunately.
> 
> /Björn
> _______________________________________________

For instance, an ap vif has a ~100ms interval and a mesh vif has a
~1000ms interval. I don't see how to avoid a per vif interval.

Steve

