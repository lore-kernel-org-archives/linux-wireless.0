Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56511 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab0G3GgG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jul 2010 02:36:06 -0400
Subject: Re: [wt PATCH 5/5] libertas: scan before assocation if no BSSID
 was given
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1280470711.14523.16.camel@dcbw.foobar.com>
References: <1280470034.14523.4.camel@dcbw.foobar.com>
	 <1280470711.14523.16.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Jul 2010 08:37:18 +0200
Message-ID: <1280471838.3710.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-07-29 at 23:18 -0700, Dan Williams wrote:
> Fix this leftover TODO from the cfg80211 conversion by doing a scan
> if cfg80211 didn't pass in the BSSID for us.  Since the scan code
> uses so much of the cfg80211_scan_request structure to build up the
> firmware command, we just fake one when the scan request is triggered
> internally.  But we need to make sure that internal 'fake' cfg82011
> scan request does get back to cfg82011 via cfg80211_scan_done().

I think you mean "does _not_ get back".

johannes

