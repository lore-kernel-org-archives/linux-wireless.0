Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shell.v3.sk ([92.60.52.57]:49331 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751775AbdF1TKR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 15:10:17 -0400
Message-ID: <1498677005.21787.1.camel@v3.sk> (sfid-20170628_211040_765379_13C2BB53)
Subject: Re: [PATCH] mac80211_hwsim: use dyndbg for debug messages
From: Lubomir Rintel <lkundrak@v3.sk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 28 Jun 2017 21:10:05 +0200
In-Reply-To: <1498662178.12531.6.camel@sipsolutions.net>
References: <20170628131726.15528-1-lkundrak@v3.sk>
         <1498662178.12531.6.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-06-28 at 17:02 +0200, Johannes Berg wrote:
> On Wed, 2017-06-28 at 15:17 +0200, Lubomir Rintel wrote:
> > The mac80211_hwsim doesn't offer a way to disable the debugging
> > output.
> > Unfortunately, it's pretty chatty, dumping a  lot of stuff into the
> > message buffer.
> 
> Why is this a problem? It's pretty much a testing tool only, and much
> of the point is to have message about it's internal state?

I do use it as a development tool. I find it very convenient to always
have a bunch of libvirt-managed LXC containers, some running hostapd
instances with various access point configurations and some used for
NetworkManager development and a mac80211_hwsim radio in each of them.

An unfortunate side-effect is that my dmesg becomes next to useless due
to the overwhelming amount of mac80211_hwsim logging.

> johannes

Lubo
