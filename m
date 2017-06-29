Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43028 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752787AbdF2NIW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Jun 2017 09:08:22 -0400
Message-ID: <1498741697.3141.2.camel@sipsolutions.net> (sfid-20170629_150839_071297_004694AE)
Subject: Re: [PATCH] mac80211_hwsim: use dyndbg for debug messages
From: Johannes Berg <johannes@sipsolutions.net>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 29 Jun 2017 15:08:17 +0200
In-Reply-To: <1498677005.21787.1.camel@v3.sk>
References: <20170628131726.15528-1-lkundrak@v3.sk>
         <1498662178.12531.6.camel@sipsolutions.net>
         <1498677005.21787.1.camel@v3.sk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-06-28 at 21:10 +0200, Lubomir Rintel wrote:
> 
> I do use it as a development tool. I find it very convenient to
> always have a bunch of libvirt-managed LXC containers, some running
> hostapd instances with various access point configurations and some
> used for NetworkManager development and a mac80211_hwsim radio in
> each of them.

Hah. Ok, I usually run it in a VM, so the output doesn't bother me at
all.

I guess I can live with this, but can you please reindent things
properly? Also, we'll have to update the wpa_supplicant hwsim testing
scripting to turn this on I guess.

johannes
