Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51154 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab0KDUzL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 16:55:11 -0400
Subject: Re: [PATCH] mac80211: unset SDATA_STATE_OFFCHANNEL when cancelling
 a scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Brian Cavagnolo <brian@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1288830056-841-1-git-send-email-brian@cozybit.com>
References: <1288830056-841-1-git-send-email-brian@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 11:52:32 -0400
Message-ID: <1288885952.3659.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-03 at 17:20 -0700, Brian Cavagnolo wrote:
> For client STA interfaces, ieee80211_do_stop unsets the relevant
> interface's SDATA_STATE_RUNNING state bit prior to cancelling an
> interrupted scan.

Would it not make more sense to fix that code to do it in a working
order?

johannes

