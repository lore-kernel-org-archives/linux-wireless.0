Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:41128 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750809Ab1CDHDI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 02:03:08 -0500
Received: by ewy10 with SMTP id 10so669389ewy.28
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 23:03:05 -0800 (PST)
Subject: Re: Powersave broken on p54
From: Luciano Coelho <coelho@ti.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1299086257.13604.17.camel@marge>
References: <1299003142.6461.12.camel@maggie>
	 <201103021813.52719.chunkeey@googlemail.com>
	 (sfid-20110302_181438_600050_FFFFFFFF80E6967A)  <1299086257.13604.17.camel@marge>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 09:03:18 +0200
Message-ID: <1299222198.7039.111.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-03-02 at 18:17 +0100, Michael Buesch wrote:
> On Wed, 2011-03-02 at 18:13 +0100, Christian Lamparter wrote:
> > sure there was the rssi->dbm update (I hope you've already updated
> > your eeprom image.)
> 
> What change to the eeprom is needed? My eeprom doesn't
> contain any rssi info (see recent NULL ptr fix).
> 
> > No idea, it looks like the ps-poll is broken, because
> > "iwconfig wlanX power timeout 10" fixes the long delays
> > almost immediately. [let's see if there's more]
> 
> So maybe it's a generic mac80211 bug? Are there other
> devices with PS issues?

We have been having some problems with PSM on the wl12xx driver too.  It
seems that it broke in the past couple of weeks as well.  So this is
most likely a problem in mac80211.  I'll try to investigate this a bit
more too.

-- 
Cheers,
Luca.

