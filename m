Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58565 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755604AbaJIPVg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 11:21:36 -0400
Message-ID: <1412868088.1828.56.camel@jlt4.sipsolutions.net> (sfid-20141009_172139_645896_020C54F6)
Subject: Re: [PATCHv3 2/2] iw: add auto parameter to set distance command
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 09 Oct 2014 17:21:28 +0200
In-Reply-To: <CAA2SeNLkf5RZsSYjYPpU=E0hHhe2c3G=cbUpy=gfp0kfwDRviQ@mail.gmail.com> (sfid-20141009_164635_670305_C371157F)
References: <1410111140-4340-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1410111140-4340-3-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1412864474.1828.51.camel@jlt4.sipsolutions.net>
	 <CAA2SeNLkf5RZsSYjYPpU=E0hHhe2c3G=cbUpy=gfp0kfwDRviQ@mail.gmail.com>
	 (sfid-20141009_164635_670305_C371157F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-10-09 at 16:46 +0200, Lorenzo Bianconi wrote:

> > Somehow you also changed nl80211.h here - you shouldn't do that at all
> > really :) I will deal with the updates of that file for iw.
> 
> I added NL80211_ATTR_WIPHY_DYN_ACK flag attribute to nl80211_attrs
> enumeration and NL80211_FEATURE_ACKTO_ESTIMATION flag attribute to
> nl80211_feature_flags. I should not? Should I use a different patch?

I never apply patches to nl80211.h - I only copy the file from the
latest kernel. That way I avoid sync issues and if then your patch
doesn't compile I know I haven't applied the kernel patch :)

So yeah - you should simply not do it at all. I'll copy if/when needed.

johannes

