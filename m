Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59285 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbcBWKmx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 05:42:53 -0500
Message-ID: <1456224168.2041.21.camel@sipsolutions.net> (sfid-20160223_114258_102734_00992015)
Subject: Re: [PATCH v2 2/2] mac80211: parse VHT info in injected frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 23 Feb 2016 11:42:48 +0100
In-Reply-To: <CAA2SeNLB+oL00Mx1BCccA4eOx6nghLUofruPSepW70VWRS8EQQ@mail.gmail.com> (sfid-20160223_112908_349476_7FF78E48)
References: <1455878585-5525-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1455878585-5525-3-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1456222250.2041.8.camel@sipsolutions.net>
	 <CAA2SeNLB+oL00Mx1BCccA4eOx6nghLUofruPSepW70VWRS8EQQ@mail.gmail.com>
	 (sfid-20160223_112908_349476_7FF78E48)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-02-23 at 11:29 +0100, Lorenzo Bianconi wrote:
> I used the previous commit scheme (mac80211: Parse legacy and HT rate
> in injected frames).

Oh, I merged something similar there? My mistake.

> I will rewrite the documentation. Should I send v3 or a different
> patch?
> 

Please resend, I didn't apply this. Perhaps you can (separately?) fix
the HT documentation as well then?

Thanks,
johannes
