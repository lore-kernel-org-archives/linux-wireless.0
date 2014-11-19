Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40075 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755188AbaKSR5I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 12:57:08 -0500
Message-ID: <1416419825.9374.12.camel@sipsolutions.net> (sfid-20141119_185711_871669_A45FB7BD)
Subject: Re: [PATCH v5 1/2] nl80211: Replace interface socket owner
 attribute with more generic one
From: Johannes Berg <johannes@sipsolutions.net>
To: Jukka Rissanen <jukka.rissanen@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Nov 2014 18:57:05 +0100
In-Reply-To: <1415892315-2911-2-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141113_162952_563314_9252CA5A)
References: <1415892315-2911-1-git-send-email-jukka.rissanen@linux.intel.com>
	 <1415892315-2911-2-git-send-email-jukka.rissanen@linux.intel.com>
	 (sfid-20141113_162952_563314_9252CA5A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-11-13 at 17:25 +0200, Jukka Rissanen wrote:
> Replace NL80211_ATTR_IFACE_SOCKET_OWNER attribute with more generic
> NL80211_ATTR_SOCKET_OWNER that can be used with other commands
> that interface creation.

Applied.

johannes

