Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36802 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753199AbbAGQcn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 11:32:43 -0500
Message-ID: <1420648358.3407.19.camel@sipsolutions.net> (sfid-20150107_173246_671276_2F58201B)
Subject: Re: [PATCH 1/3] mac80211: consider only relevant vifs for
 radar_required calculation
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 07 Jan 2015 17:32:38 +0100
In-Reply-To: <CAB3XZEdJw=vaLVO+5YXkH1ZPerKYC4s-_+E0nzL+XUXMiZQLkw@mail.gmail.com> (sfid-20150107_165842_207074_75213483)
References: <1420366399-31535-1-git-send-email-eliad@wizery.com>
	 <1420542274.1966.21.camel@sipsolutions.net>
	 <1420553111.1966.32.camel@sipsolutions.net>
	 <1420553688.1966.33.camel@sipsolutions.net>
	 <CAB3XZEctcBuPG6f4ZrZFV5O3Z7+hi+ShFdwvFXdJovG2KeAufQ@mail.gmail.com>
	 <1420570976.1966.34.camel@sipsolutions.net>
	 <CAB3XZEdWsDsnVr_bJ3ScSYy6MEQ7VXvWw4VC36zheYN-B=yLrA@mail.gmail.com>
	 <CAB3XZEdJw=vaLVO+5YXkH1ZPerKYC4s-_+E0nzL+XUXMiZQLkw@mail.gmail.com>
	 (sfid-20150107_165842_207074_75213483)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-01-07 at 17:58 +0200, Eliad Peller wrote:

> ok, sent a new patchset.
> 
> there were some missing updates of local->radar_detect_enabled, so i
> preferred to simply remove it altogether and check for radar detection
> directly when needed (i.e. on scan/roc).

Sounds good, thanks.

> ap_ht_40mhz_intolerant_ap still seems to fail here, but it fails even
> when running only this test, without any of my patches applied.
> now i get the same error with my patches applied ("Exception: AP did
> not move to 40 MHz channel") instead of the EBUSY one.
> 
> i'll try debugging this issue as well.

Well, if you want to :)
It's not related to your patches I think, and I saw it passing w/o your
patches applied.

johannes

