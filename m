Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:36463 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753734Ab2FMLhd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 07:37:33 -0400
Received: by lahi5 with SMTP id i5so415246lah.0
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2012 04:37:29 -0700 (PDT)
Message-ID: <1339587447.3840.272.camel@cumari.coelho.fi> (sfid-20120613_133753_379544_1C9B8729)
Subject: Re: [PATCH] nl80211: specify RSSI threshold when scanning
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Pedersen <c_tpeder@qca.qualcomm.com>,
	kvalo@qca.qualcomm.com, ath6kl-devel@qualcomm.com,
	linux-wireless@vger.kernel.org, victorg@ti.com
Date: Wed, 13 Jun 2012 14:37:27 +0300
In-Reply-To: <1339566003.4519.1.camel@jlt3.sipsolutions.net>
References: <1339533801-32016-1-git-send-email-c_tpeder@qca.qualcomm.com>
	 <1339566003.4519.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-13 at 07:40 +0200, Johannes Berg wrote:
> On Tue, 2012-06-12 at 13:43 -0700, Thomas Pedersen wrote:
> > Support configuring an RSSI threshold in dBm (s32) when requesting
> > scheduled scan, below which a BSS won't be reported by the cfg80211
> > driver.
> 
> I'm confused -- were you going to do scheduled scan only? Makes sense,
> but if you could maybe change the subject a bit to "specify ... in
> scheduled scan"?

It makes more sense with scheduled scans, but maybe it is also desirable
with normal scans to reduce the amount of scan results traffic?

At least if we consider the intermediate scan results that Victor has
been working on... We may want to report all scan results at the end,
but only send intermediate events if all the matches are satisfied, for
example.

Just thinking out loud a bit.

--
Luca.

