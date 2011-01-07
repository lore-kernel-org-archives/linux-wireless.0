Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63444 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab1AGAch (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 19:32:37 -0500
Received: by pwj3 with SMTP id 3so2263451pwj.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jan 2011 16:32:36 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19750.24326.51491.287733@gargle.gargle.HOWL>
Date: Fri, 7 Jan 2011 06:02:06 +0530
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Jouni.Malinen@atheros.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v2] cfg80211: Add HT BSS attributes
In-Reply-To: <AANLkTim9iM0rLgg5PoVJvuq7WHBnCuf4=aemKAUt3gb8@mail.gmail.com>
References: <19749.32067.311517.479374@gargle.gargle.HOWL>
	<AANLkTim9iM0rLgg5PoVJvuq7WHBnCuf4=aemKAUt3gb8@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Thu, Jan 6, 2011 at 12:28 AM, Sujith <m.sujith@gmail.com> wrote:
> > From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> >
> > Add two new per-BSS attributes to allow configuration of
> > HT capabilites and operational parameters by hostapd.
> >
> > Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> > ---
> > v2: Initialize values and set the parameters in managed mode also.
> 
> Can you split this up into two patches, one for cfg80211 and another
> for mac80211?

Hm, I sent a mail yesterday dropping this patch,
looks like it never reached the list.

Sujith
