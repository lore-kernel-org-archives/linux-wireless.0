Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50582 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752587AbdIFK1N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Sep 2017 06:27:13 -0400
Message-ID: <1504693631.13457.4.camel@sipsolutions.net> (sfid-20170906_122716_271615_6ED27E66)
Subject: Re: [PATCH] wireless: allow send peer mac in rssi cqm notify
From: Johannes Berg <johannes@sipsolutions.net>
To: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, pradeep718@tamu.edu
Date: Wed, 06 Sep 2017 12:27:11 +0200
In-Reply-To: <1503435112-26204-1-git-send-email-pradeepc@codeaurora.org>
References: <1503435112-26204-1-git-send-email-pradeepc@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-08-22 at 13:51 -0700, Pradeep Kumar Chitrapu wrote:
> Extend cqm rssi notifier apis to include peer mac address. Currently
> netlink cqm msg already accepts the mac. With this change just
> passing the mac address as an argument to cfg and mac80211 apis.

This probably somehow interacts with the other patches you sent in this
area, like enabling the CQM stuff for AP mode, but that *really* needs
to be more than three patches without any substantial commit log and
documentation updates.

I'm not convinced that this makes sense at all.

johannes
