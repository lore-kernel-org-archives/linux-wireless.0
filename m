Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48504 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab2DEOGa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2012 10:06:30 -0400
Message-ID: <1333634786.3494.19.camel@jlt3.sipsolutions.net> (sfid-20120405_160643_993464_3069B793)
Subject: Re: 802.11ac support
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh <maheshp@posedge.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Chakra Parvathaneni <chakra@posedge.com>
Date: Thu, 05 Apr 2012 16:06:26 +0200
In-Reply-To: <4F7D1DE4.5000000@posedge.com>
References: <f17c700977012ada368da4f339b9c639@posedge.com>
	  <1329933458.4657.2.camel@jlt3.sipsolutions.net>
	  <1329937072.4657.4.camel@jlt3.sipsolutions.net>
	  <4F471F40.8060503@posedge.com>
	  <1330070145.3426.8.camel@jlt3.sipsolutions.net>
	  <4F4772AB.9000305@posedge.com>
	  <CAJ-VmomfVCc0oQMjfwsrheC+Z2k3+-czo4F9GeeO=upHiHnQxg@mail.gmail.com>
	  (sfid-20120225_202329_108179_7C3BAD32) <1330205424.3509.5.camel@jlt3.sipsolutions.net>
	  <eab3dfdc8ebc87ec08ca64db9f237d90@posedge.com>
	  (sfid-20120402_104501_564453_6BF9F70F) <1333454805.3574.14.camel@jlt3.sipsolutions.net>
	 <4F7D1DE4.5000000@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-04-05 at 09:51 +0530, Mahesh wrote:

> > In any case, here's my list of things I think will/may need to be done
> > for 11ac in the stack:
> >   * extend regulatory framework (cfg80211)
> >   * advertise VHT capabilities (nl80211/cfg80211/mac80211&  each driver)
> >   * advertise VHT in scan (mac80211)
> >   * advertise VHT in assoc req (mac80211)
> >   * advertise VHT in P2P probe responses (wpa_supplicant)
> >   * advertise VHT in AP/GO mode beacons/probe responses
> >     (wpa_supplicant/hostapd)
> >   * handle per-station VHT capa (mac80211, wpa_s)
> >   * extended CSA (mac80211)
> >   * VHT transmit power envelope/extended power constraint (mac80211)
> >   * quiet channels?
> >   * HT/VHT basic rate handling?
> >   * neighbor reports?
> >   * beamforming action frame support? (mac80211)

> Thanks for listing the 11ac requirements. will work on those and post my 
> updates.

When you start working on them, I suggest roughly the list in the order
above. Regulatory might not be the first thing though.

If you do though, please don't do everything and then post all patches
at once -- each of those items should be self-contained enough to post
separately. This helps synchronise with others who might be working on
it and also helps since we can review the code and suggest corrections
if needed.

Let me know if you need more info!

Thanks,
johannes

