Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54258 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbaKDPhq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 10:37:46 -0500
Message-ID: <1415115463.2064.20.camel@sipsolutions.net> (sfid-20141104_163749_680087_D9336E9F)
Subject: Re: [PATCH] cfg80211: fix nl80211 cmd id in nl80211_send_mpath()
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Date: Tue, 04 Nov 2014 16:37:43 +0100
In-Reply-To: <1415114098-25517-1-git-send-email-henning.rogge@fkie.fraunhofer.de> (sfid-20141104_161520_549207_D2F18EDB)
References: <1415114098-25517-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
	 (sfid-20141104_161520_549207_D2F18EDB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-11-04 at 16:14 +0100, Henning Rogge wrote:
> Netlink command for nl80211_send_mpath() should be NL80211_CMD_NEW_MPATH.

Doh. Applied, of course.

johannes

