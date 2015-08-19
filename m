Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58628 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbbHSSCc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 14:02:32 -0400
Message-ID: <1440007349.2089.8.camel@sipsolutions.net> (sfid-20150819_200235_261684_1DC4F736)
Subject: Re: set channel from radiotap headers during injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
	Allan Matthew <allanm84@gmail.com>,
	linux-wireless@vger.kernel.org
Date: Wed, 19 Aug 2015 20:02:29 +0200
In-Reply-To: <55D4C068.70607@candelatech.com>
References: <CAEnVuW0JnU5yuAYBWsRfOo_S=GUK5vZzr6XqnNHHOeufmT-uiQ@mail.gmail.com>
	 <CAEnVuW1FcyBj2+ti8U8KF+rM0xO_Q+rw6PxXqgWy8WO0vRX6yg@mail.gmail.com>
	 (sfid-20150814_234019_925894_43212D3A) <1439983495.2089.7.camel@sipsolutions.net>
	 <55D4C068.70607@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-08-19 at 10:44 -0700, Ben Greear wrote:
> 
> At least with ath9k, it is possible to send HT20 frames
> when the radio has other vifs on the same radio sending HT40 frames, 
> for instance.
> (And rate-ctrl will do the same thing even for an 'ht40' vif).

Yes, but that's pure rate control.

> ath10k hardware has same general ability, but you have no good way to
> get radiotap info to the firmware at this time.
> 
> As long as the center freq is the same, it might also be possible to 
> do smaller bandwith encodings as well.

I don't think this is true - I believe the clock settings are different
for 5 and 10 MHz (vs. each other and higher bandwidths)


johannes
