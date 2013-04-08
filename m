Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.piware.de ([213.9.93.70]:39025 "EHLO www.piware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965359Ab3DHOzm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 10:55:42 -0400
Date: Mon, 8 Apr 2013 16:55:38 +0200
From: Martin Pitt <martin.pitt@ubuntu.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH v2] mac80211_hwsim: Register and bind to driver
Message-ID: <20130408145538.GB3092@piware.de> (sfid-20130408_165546_019562_614EEE52)
References: <20130408093001.GE2818@piware.de>
 <1365431569.25475.16.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1365431569.25475.16.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes,

Johannes Berg [2013-04-08 16:32 +0200]:
> On Mon, 2013-04-08 at 11:30 +0200, Martin Pitt wrote:
> > Properly register our mac80211_hwsim_driver, attach it to the platform bus.
> > Bind newly created hwsim devices to that driver, so that our wlan devices get
> > a proper "driver" sysfs attribute.
> > 
> > This makes mac80211_hwsim interfaces work with NetworkManager.
> 
> Applied.

Splendid, thank you!

Martin

-- 
Martin Pitt                        | http://www.piware.de
Ubuntu Developer (www.ubuntu.com)  | Debian Developer  (www.debian.org)
