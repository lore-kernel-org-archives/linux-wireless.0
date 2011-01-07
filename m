Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34044 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab1AGCjp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 21:39:45 -0500
Received: by iyi12 with SMTP id 12so15423979iyi.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jan 2011 18:39:45 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <19750.31960.215220.239389@gargle.gargle.HOWL>
Date: Fri, 7 Jan 2011 08:09:20 +0530
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v2] cfg80211: Add HT BSS attributes
In-Reply-To: <AANLkTimgd-EbLBe6KHnj5_9Paeg++rp1v8J5s5hy_NOa@mail.gmail.com>
References: <19749.32067.311517.479374@gargle.gargle.HOWL>
	<19749.37051.292861.996698@gargle.gargle.HOWL>
	<19750.24410.495583.789895@gargle.gargle.HOWL>
	<AANLkTintPXzmiGnjEQvXUO3hVCW9J4tGn=MookTx1qBM@mail.gmail.com>
	<AANLkTi=ZcigYLqqmhHc638_AxSODWrVrTV5KELRws3XX@mail.gmail.com>
	<19750.30510.548719.848168@gargle.gargle.HOWL>
	<AANLkTimgd-EbLBe6KHnj5_9Paeg++rp1v8J5s5hy_NOa@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Halperin wrote:
> On Thu, Jan 6, 2011 at 6:15 PM, Sujith <m.sujith@gmail.com> wrote:
> > Daniel Halperin wrote:
> >> Yeah, me too.  Isn't greenfield mode (whether there are legacy devices
> >> around) part of the operating capabilities and should be supported by
> >> hostapd?
> >
> > Yes, hostapd does check if there are non-GF stations in the BSS and updates
> > the HT operation mode parameters. But the nl80211 interface hook is currently
> > not implemented.
> >
> 
> right.. so don't we want this patch? :)  Sorry if I'm being obtuse

The Greenfield status is part of opmode (see operation_mode in struct ieee80211_ht_info).
This is already handled by mac80211 through NL80211_ATTR_BSS_HT_OPMODE for AP mode.

Sujith
