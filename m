Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44322 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab2KGIE6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2012 03:04:58 -0500
Message-ID: <1352275534.9854.6.camel@jlt4.sipsolutions.net> (sfid-20121107_090509_999521_204E4688)
Subject: Re: Clarification needed on Last Tx Rate statistic update
From: Johannes Berg <johannes@sipsolutions.net>
To: Saravana <saravanad@posedge.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 07 Nov 2012 09:05:34 +0100
In-Reply-To: <509A11F9.8050108@posedge.com>
References: <509A11F9.8050108@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-07 at 13:17 +0530, Saravana wrote:

> Could somebody clarify why the statistics update happens only when the 
> rate control is done by the hardware(flag IEEE80211_HW_HAS_RATE_CONTROL 
> is set)?

In the other case, it's set to txrc.reported_rate upon transmission, so
it's not the *last* rate, but more accurately the highest
performing/probability rate.

johannes

