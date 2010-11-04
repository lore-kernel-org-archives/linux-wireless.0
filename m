Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44097 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab0KDUsd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 16:48:33 -0400
Subject: Re: [RFC 05/15] nl80211: call periodic_start and periodic_stop
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1288612336-2830-6-git-send-email-luciano.coelho@nokia.com>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
	 <1288612336-2830-6-git-send-email-luciano.coelho@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 11:44:09 -0400
Message-ID: <1288885449.3659.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-11-01 at 13:52 +0200, Luciano Coelho wrote:
> Now that cfg80211 has support for periodic scan, we call those ops in the
> nl80211 code.

Need to advertise these too in the wiphy cmd nl80211.

johannes

