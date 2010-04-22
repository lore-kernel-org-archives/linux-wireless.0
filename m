Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43181 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab0DVIqR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Apr 2010 04:46:17 -0400
Subject: Re: [RFC PATCHv3 2/2] cfg80211: Remove default dynamic PS timeout
 value
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1271739508.6205.5712.camel@wimaxnb.nmp.nokia.com>
References: <1271409274-17162-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1271409274-17162-3-git-send-email-juuso.oikarinen@nokia.com>
	 <1271688229.23671.2.camel@jlt3.sipsolutions.net>
	 <1271739508.6205.5712.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Apr 2010 10:46:14 +0200
Message-ID: <1271925974.3605.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-04-20 at 07:58 +0300, Juuso Oikarinen wrote:

> > Or actually, wouldn't it make sense to move the pm_qos logic here (into
> > cfg80211)?
> 
> I thought about that but then I realised that would contradict with one
> of the arguments presented against the dynamic ps API I proposed
> earlier. The argument specifically stated we don't want the API as in
> the future there will be some uber-cool psm implementations in some
> (full-mac?) chipsets that don't even use a value like this.
> 
> Therefore I opted to leave the implementation in mac80211, thinking that
> the entire configuration option will be removed from the cfg80211 once
> the wext is gone.

Fair enough. I just thought that IFF the device wants to use a similar
algorithm, it should use the exact same one. But we can cross that
bridge when we have a device.

johannes

