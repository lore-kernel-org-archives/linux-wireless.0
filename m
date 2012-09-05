Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:57461 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750826Ab2IEHRI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 03:17:08 -0400
Date: Wed, 5 Sep 2012 10:16:53 +0300
From: Jouni Malinen <j@w1.fi>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	ath5k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath5k: add support of HW encryption in management frames
Message-ID: <20120905071653.GB3629@w1.fi> (sfid-20120905_091713_465453_6FCF6F28)
References: <1346146446-628-1-git-send-email-yeohchunyeow@gmail.com>
 <1346746298.3737.0.camel@jlt4.sipsolutions.net>
 <CAEFj9861rR+yEcJbtZjnwqO5LQXEbjRgxaM+StTBkJKxXPximw@mail.gmail.com>
 <20120904102204.GA2541@w1.fi>
 <CAEFj984r=4HN5qC6yJqFEuFud1z+J5F7gz=oahnpv6y-_a-MyQ@mail.gmail.com>
 <CAEFj986jSwLb0bdsW_-moOZ_WwrsmW5aHW+7SEq-jKcXbmk5FA@mail.gmail.com>
 <1346758521.3737.28.camel@jlt4.sipsolutions.net>
 <CAEFj986eBvbndfY8QSM_JccViug-Cr6nyM+p-qz_EnNcB_67dA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAEFj986eBvbndfY8QSM_JccViug-Cr6nyM+p-qz_EnNcB_67dA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 05, 2012 at 12:41:16AM +0800, Yeoh Chun-Yeow wrote:
> By the way, current secured mesh requires the AES CMAC to be enabled.
> But without enabling IEEE80211_HW_MFP_CAPABLE, the key cannot be added
> since this cipher suite is considered not supported. But actually AES
> CMAC can be done in software. Any work around on this?

Could you please describe what exactly you mean with "current secured
mesh requires the AES CMAC to be enabled" and what is that claim based
on? Any pointers to the specific standard clause(s) that say that?

-- 
Jouni Malinen                                            PGP id EFC895FA
