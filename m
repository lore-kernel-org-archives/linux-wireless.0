Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56496 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751159AbdFVGac (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 02:30:32 -0400
Message-ID: <1498113028.2246.4.camel@sipsolutions.net> (sfid-20170622_083036_382308_E583DF41)
Subject: Re: cfg80211_ops
From: Johannes Berg <johannes@sipsolutions.net>
To: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        "Tobin C. Harding" <me@tobin.cc>, linux-wireless@vger.kernel.org
Date: Thu, 22 Jun 2017 08:30:28 +0200
In-Reply-To: <a3105fed-a02b-cd0e-1f4a-e3f9a0b7dd1f@quantenna.com> (sfid-20170622_025419_012718_7F9D64F7)
References: <20170622000347.GA15458@eros>
         <a3105fed-a02b-cd0e-1f4a-e3f9a0b7dd1f@quantenna.com>
         (sfid-20170622_025419_012718_7F9D64F7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-06-21 at 17:53 -0700, Igor Mitsyanko wrote:
> 
> > scan
> > add_key
> > get_key
> > del_key
> > sat_default_key
> > connect
> > disconnect
> > set_wiphy_params
> 
> Hi, is this for STA-only? I guess you also need
> mgmt_frame_register
> mgmt_tx

For really basic operation, I don't think you need that, and might even
be able to get away withou set_wiphy_params.

Also, set_default_key is, IIRC, not needed in WPA/WPA2 client mode, but
may be needed for WEP - not sure off the top of my head.

johannes
