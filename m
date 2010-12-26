Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:52571 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325Ab0LZSgP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Dec 2010 13:36:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
Date: Sun, 26 Dec 2010 19:35:13 +0100
Cc: Alan Stern <stern@rowland.harvard.edu>,
	linux-pm@lists.linux-foundation.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	Ido Yariv <ido@wizery.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
References: <AANLkTimj0E3Rz_8WQrU4wGg3ONyXzkUT9+U3Xqz7Cq0X@mail.gmail.com> <201012261245.29680.rjw@sisk.pl> <AANLkTimzNXyirnV9wGXf6R454bwEDf=poBZzevAWXEUd@mail.gmail.com>
In-Reply-To: <AANLkTimzNXyirnV9wGXf6R454bwEDf=poBZzevAWXEUd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012261935.13238.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, December 26, 2010, Ohad Ben-Cohen wrote:
> On Sun, Dec 26, 2010 at 1:45 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Why does the driver need the device to be reset even though it hasn't
> > been suspeneded yet?
> 
> Because it is asked to stop the hardware by mac80211.

So I guess the mac80211 layer should ask it to start it again.

Thanks,
Rafael
