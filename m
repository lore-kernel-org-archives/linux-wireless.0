Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51914 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934259Ab3BMQNl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 11:13:41 -0500
Message-ID: <1360772013.8868.27.camel@jlt4.sipsolutions.net> (sfid-20130213_171349_476090_54C60B99)
Subject: Re: [PATCH] mac80211: start auth/assoc timeout on frame status
From: Johannes Berg <johannes@sipsolutions.net>
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: Sujith Manoharan <sujith@msujith.org>,
	linux-wireless@vger.kernel.org
Date: Wed, 13 Feb 2013 17:13:33 +0100
In-Reply-To: <511BB425.2030400@neratec.com>
References: <1359638935-16613-1-git-send-email-johannes@sipsolutions.net>
	 <1359992600.10311.25.camel@jlt4.sipsolutions.net>
	 <511B9807.6000200@neratec.com>
	 <1360765274.8868.13.camel@jlt4.sipsolutions.net>
	 <511BA1E5.40402@neratec.com>
	 <1360765934.8868.14.camel@jlt4.sipsolutions.net>
	 <1360766384.8868.15.camel@jlt4.sipsolutions.net>
	 <511BAF4D.7090706@neratec.com>
	 <20763.45827.549496.955059@gargle.gargle.HOWL>
	 <511BB425.2030400@neratec.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-13 at 16:41 +0100, Wojciech Dubowik wrote:
> On 02/13/2013 04:36 PM, Sujith Manoharan wrote:
> > Wojciech Dubowik wrote:
> >> I don't see anymore timeouts. Sometimes station tries to authenticate,
> >> sends direct probe, timeouts and then goes again with auth message.
> > If you are using ath9k_rate_control, can you check if you still see the issue
> > with minstrel_ht ?
> I am using minstrel.
> 
> The above problem actually came from my  setup. I was using
> my hostpad with trial support for ap_scan=2, that's what I am
> trying to work on now. My test scripts are not very mature yet...
> 
> With stock hostapd and ap_scan=1 it seems to work quite
> fine.

Ok. Can I add your tested-by?

johannes

