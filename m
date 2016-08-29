Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42872 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756669AbcH2Hpm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Aug 2016 03:45:42 -0400
Message-ID: <1472456732.14003.0.camel@sipsolutions.net> (sfid-20160829_094548_548450_F776D27F)
Subject: Re: mac80211_hwsim: handling RSSI
From: Johannes Berg <johannes@sipsolutions.net>
To: Ramon Fontes <ramonreisfontes@gmail.com>,
        linux-wireless@vger.kernel.org
Date: Mon, 29 Aug 2016 09:45:32 +0200
In-Reply-To: <CAK8U23YMkeYTQb2HNuqG9xfeKkv50X0MKE5r7vY=-icExF7xWA@mail.gmail.com> (sfid-20160826_235440_788454_BCC5ED09)
References: <CAK8U23YMkeYTQb2HNuqG9xfeKkv50X0MKE5r7vY=-icExF7xWA@mail.gmail.com>
         (sfid-20160826_235440_788454_BCC5ED09)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-08-26 at 23:53 +0200, Ramon Fontes wrote:
> Hi,
> 
> I am developing a wireless network emulator
> (https://github.com/intrig-unicamp/mininet-wifi) and I was wondering
> what is the best way to change the RSSI information provided by
> mac80211_hwsim. I am able to calculate the RSSI with my emulator, but
> the RSSI is not updated by mac80211_hwsim, of course. Do I have to
> make changes in nl80211?
> 

Check out wmediumd.

johannes
