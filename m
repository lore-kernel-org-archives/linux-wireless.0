Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:59164 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaJIUtS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 16:49:18 -0400
Received: by mail-wg0-f42.google.com with SMTP id z12so2315180wgg.25
        for <linux-wireless@vger.kernel.org>; Thu, 09 Oct 2014 13:49:16 -0700 (PDT)
Date: Thu, 9 Oct 2014 22:49:12 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH] cfg80211: set the rates mask in connection probes over
 specified freq
Message-ID: <20141009204912.GB19745@gobelin> (sfid-20141009_224921_838348_FBE559DF)
References: <1412674938-13071-1-git-send-email-karl.beldan@gmail.com>
 <1412847177.1828.33.camel@jlt4.sipsolutions.net>
 <20141009130035.GB20644@magnum.frso.rivierawaves.com>
 <1412861162.1828.45.camel@jlt4.sipsolutions.net>
 <20141009162616.GA27065@magnum.frso.rivierawaves.com>
 <1412879793.1828.61.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1412879793.1828.61.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 09, 2014 at 08:36:33PM +0200, Johannes Berg wrote:
> Heh, so I guess this goes way back ... what does it actually affect
> really though? only connections with iw, which should really not be done
> that much? potentially wpa_s with wext, though I'm not even sure that
> works?
> 
For wext I wouldn't know.

> Either way - is it worth for 3.18/stable?
> 
Your call.
 
Karl
