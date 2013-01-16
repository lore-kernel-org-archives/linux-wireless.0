Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53008 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757304Ab3APW0g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 17:26:36 -0500
Message-ID: <1358375221.15012.25.camel@jlt4.sipsolutions.net> (sfid-20130116_232639_444912_FE02F5A7)
Subject: Re: [PATCH] cfg80211: Allow use_mfp to be specified with the
 connect command
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 16 Jan 2013 23:27:01 +0100
In-Reply-To: <20130115151557.GA17318@jouni.qca.qualcomm.com>
References: <20130115151557.GA17318@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-01-15 at 17:15 +0200, Jouni Malinen wrote:
> The NL80211_ATTR_USE_MFP attribute was originally added for
> NL80211_CMD_ASSOCIATE, but it is actually as useful (if not even more
> useful) with NL80211_CMD_CONNECT, so process that attribute with the
> connect command, too.

Applied.

johannes

