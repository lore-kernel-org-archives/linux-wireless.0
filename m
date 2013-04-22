Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45983 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab3DVOSk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 10:18:40 -0400
Message-ID: <1366640311.8637.25.camel@jlt4.sipsolutions.net> (sfid-20130422_161843_726131_DEA2123B)
Subject: Re: [PATCH v6 1/3] mac80211: improve the rate control API
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, karl.beldan@gmail.com
Date: Mon, 22 Apr 2013 16:18:31 +0200
In-Reply-To: <1366640083-1054-1-git-send-email-nbd@openwrt.org>
References: <1366640083-1054-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-22 at 16:14 +0200, Felix Fietkau wrote:
> Allow rate control modules to pass a rate selection table to mac80211
> and the driver. This allows drivers to fetch the most recent rate
> selection from the sta pointer for already buffered frames. This allows
> rate control to respond faster to sudden link changes and it is also a
> step towards adding minstrel_ht support to drivers like iwlwifi.

Applied all. Karl, thanks for the detailed review!

johannes

