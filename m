Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197]:58376 "EHLO
	mta2.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbYEJVsd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 17:48:33 -0400
Received: from X61.NetworkingUnlimited.com
 (ool-43503a0c.dyn.optonline.net [67.80.58.12]) by mta2.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0K0O00FS39WWF420@mta2.srv.hcvlny.cv.net> for
 linux-wireless@vger.kernel.org; Sat, 10 May 2008 17:48:32 -0400 (EDT)
Date: Sat, 10 May 2008 17:48:30 -0400
From: Vincent C Jones <v.jones@networkingunlimited.com>
Subject: Re: iwl4965 - wpa_supplicant can't see 5Ghz frequencies -	2.6.26-rc1
 kernel
In-reply-to: <1ba2fa240805101156q4dc52c2bt47d2f6e51b611eea@mail.gmail.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless@vger.kernel.org
Message-id: <1210456110.3787.26.camel@X61.NetworkingUnlimited.com> (sfid-20080510_234837_687832_85B11BA1)
MIME-version: 1.0
Content-type: text/plain
References: <1210352234.3763.23.camel@X61.NetworkingUnlimited.com>
 <1ba2fa240805091423y680b6706ta124eaaed73c81c0@mail.gmail.com>
 <1210376474.3856.7.camel@X61.NetworkingUnlimited.com>
 <1ba2fa240805091712gccaec9cibdab621e8d1c9ba7@mail.gmail.com>
 <1210430367.3778.9.camel@X61.NetworkingUnlimited.com>
 <1210434402.3787.7.camel@X61.NetworkingUnlimited.com>
 <1ba2fa240805101156q4dc52c2bt47d2f6e51b611eea@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sat, 2008-05-10 at 21:56 +0300, Tomas Winkler wrote:
> >
> > May be more to this than just missing 802.11a channel reporting...
> > walked to within range of a NetGear dual-band 802.11N 5GHz/11G 2.4GHz AP
> > and could not even see the 802.11A side of the AP, (while another
> > machine was associated with it, so both halves of the AP were up).
> > I associated on the G channel, then tried to force an association on the
> > A channel by setting the frequency with iwconfig. At some point, I got
> > the following (note that I could still associate with the G channel when
> > done):
> >
> > ay 10 11:20:04 X61 kernel: ------------[ cut here ]------------
> > May 10 11:20:04 X61 kernel: WARNING: at
> > include/../net/mac80211/rate.h:153 rs_get_rate+0x159/0x194 [iwl4965]()
> 
> Something went wrong with station management.  Do you use same BSSID
> on the both interfaces A and G?
> 
> Thanks
> Tomas

No. 
1st Floor-NetGear Dual Band AGN A/N on 36, BSSID = NetworkingUnlimited 
                                  G on 11, BSSID = NetworkingUnlimited-G
2nd Floor - 3Com POE A/G in A modeA on 48, BSSID = NetworkingUnlimited


