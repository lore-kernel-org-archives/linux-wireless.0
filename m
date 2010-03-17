Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42092 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab0CQQFR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 12:05:17 -0400
Subject: Re: [RFC PATCHv2 0/2] mac80211: cfg80211: Roam trigger support
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1268805772.10120.603.camel@wimaxnb.nmp.nokia.com>
References: <1268657751-1042-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1268776349.8918.9.camel@jlt3.sipsolutions.net>
	 <1268805772.10120.603.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Mar 2010 09:05:16 -0700
Message-ID: <1268841917.5989.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-03-17 at 08:02 +0200, Juuso Oikarinen wrote:

> > I'm curious. How does the HW/firmware do this?
> 
> > In my testing on some hw, the beacon RSSI fluctuated wildly, so you'd
> > have to set the hysteresis pretty high.
> 
> The HW/firmware can be configured with parameters related to averaging,
> which will smoothen the worst of the fluctuation at least between single
> frames.

Ok, cool. Thanks for taking the time to answer :)

> Still, there is the WLAN tendency of a very steep RSSI curve, so we'll
> probably end up with a relatively high hysteresis. Figuring out good
> values for the config is still to-be-done.

Right. And it will be a tradeoff between roaming decision speed and
battery life.

johannes

