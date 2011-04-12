Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61401 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab1DLLW1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 07:22:27 -0400
Received: by fxm17 with SMTP id 17so4196296fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 04:22:25 -0700 (PDT)
Subject: Re: [PATCH 3/4] mac80211: Add function to build HT caps
From: Alexander Simon <alexander.simon@saxnet.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1302607008.3639.6.camel@jlt3.sipsolutions.net>
References: <1302604964.2139.5.camel@alex-2>
	 <loom.20110412T130449-831@post.gmane.org>
	 <1302607008.3639.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 13:22:22 +0200
Message-ID: <1302607342.8929.1.camel@alex-2>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, den 12.04.2011, 13:16 +0200 schrieb Johannes Berg:
> On Tue, 2011-04-12 at 11:06 +0000, Alexander Simon wrote:
> 
> > +u8 *ieee80211_ie_build_ht_cap(u8 *pos, struct ieee80211_supported_band *sband,
> > +                              u16 cap)
> 
> It makes no sense to pass cap as an argument since it's taken from the
> sband.
> 
> johannes
> 
Not true, in ieee80211_add_ht_ie in work.c cap is modified before.

Alex

