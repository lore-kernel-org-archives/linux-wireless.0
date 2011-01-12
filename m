Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48935 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab1ALK2Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 05:28:16 -0500
Received: by gxk9 with SMTP id 9so150773gxk.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 Jan 2011 02:28:15 -0800 (PST)
Subject: Re: Mesh join/leave
From: Steve Brown <sbrown@cortland.com>
Reply-To: sbrown@cortland.com
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1294823034.3639.15.camel@jlt3.sipsolutions.net>
References: <1294780828.2383.0.camel@mythtv.ewol.com>
	 <1294823034.3639.15.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 05:28:07 -0500
Message-ID: <1294828087.16447.2.camel@mythtv.ewol.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-12 at 10:03 +0100, Johannes Berg wrote:
> On Tue, 2011-01-11 at 16:20 -0500, Steve Brown wrote:
> > In testing this, the command "iw mesh0 mesh leave" doesn't stop
> > beaconing. Beaconing continues with a null mesh id.
> > 
> > Is this the intended behavior?
> 
> No, it's not -- what driver are you using?
> 
> johannes
> 
ath9k with adapter AR9160 802.11abgn Wireless PCI Adapter (168c:2082)

Steve



