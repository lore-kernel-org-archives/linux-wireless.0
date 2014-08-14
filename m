Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48424 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689AbaHNL5i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2014 07:57:38 -0400
Message-ID: <1408017452.4371.1.camel@jlt4.sipsolutions.net> (sfid-20140814_135741_727264_E36249C7)
Subject: Re: [PATCH v2 1/2] cfg80211: clarify BSS probe response vs. beacon
 data
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Arend van Spriel <arend@broadcom.com>
Date: Thu, 14 Aug 2014 13:57:32 +0200
In-Reply-To: <CAB3XZEf95f+TeTtCOGC-9XrkEYe9Zh1oxPjXxsnCiTaGm9Rzjg@mail.gmail.com> (sfid-20140814_133843_831376_A5A28644)
References: <1408014478-20401-1-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEf95f+TeTtCOGC-9XrkEYe9Zh1oxPjXxsnCiTaGm9Rzjg@mail.gmail.com>
	 (sfid-20140814_133843_831376_A5A28644)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-08-14 at 14:38 +0300, Eliad Peller wrote:

> > @@ -982,11 +983,12 @@ cfg80211_inform_bss_width_frame(struct wiphy *wiphy,
> > +       ies->from_beacon = !ieee80211_is_probe_resp(mgmt->frame_control);
> it's basically the same, but i think ieee80211_is_beacon() is a bit
> more straight-forward :)

Yeah, makes sense. I was just copy/pasting it from the if below :)

johannes

