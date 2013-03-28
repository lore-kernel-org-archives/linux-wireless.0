Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42375 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab3C1JXy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 05:23:54 -0400
Message-ID: <1364462493.8312.8.camel@jlt4.sipsolutions.net> (sfid-20130328_102358_504580_B5AA90A6)
Subject: Re: [PATCH] mac80211: fix uninitialized variable
From: Johannes Berg <johannes@sipsolutions.net>
To: Vincent <vincent.stehle@laposte.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1364461894-30555-1-git-send-email-vincent.stehle@laposte.net>
References: <1364461894-30555-1-git-send-email-vincent.stehle@laposte.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Mar 2013 10:21:33 +0100
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-03-28 at 10:11 +0100, Vincent wrote:
> Fix one code path where chanctx_conf is tested as being non-NULL while it may
> be uninitialized.

No, you're wrong, presumably misled by the compiler.

johannes

