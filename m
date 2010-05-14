Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:37873 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754271Ab0ENIKj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 04:10:39 -0400
Received: from vs3014.wh2.ocn.ne.jp (125.206.180.187)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0691684637
	for <linux-wireless@vger.kernel.org>; Fri, 14 May 2010 17:10:37 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/3] cfg80211: Add nl80211 antenna configuration
Date: Fri, 14 May 2010 17:10:16 +0900
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	holgerschurig@gmail.com
References: <20100512082231.26565.16730.stgit@tt-desk> <20100512082325.26565.46809.stgit@tt-desk> <1273652994.3979.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1273652994.3979.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201005141710.16168.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 12 May 2010 17:29:54 Johannes Berg wrote:
> On Wed, 2010-05-12 at 17:23 +0900, Bruno Randolf wrote:
> > +	CMD(get_antenna, GET_ANTENNA);
> 
> I'm wondering ... does get_antenna really make sense as a separate
> command? Seems like we could just as well report it as part of the wiphy
> information dump?

i don't insist on a separate command, but i don't know where else to put it. 

you mean "iw phy0 info"? that shows more a list of possible configuration 
options than the actual current configuration: like the list of channels, 
modes, bitrates, supported commands, etc... with the exception of coverage 
class... i feel like it doesn't really fit in there. maybe iw needs some 
command to show the device configuration (channel, antenna, essid, bssid, etc 
...)???

bruno
