Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47454 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab3A2TqR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 14:46:17 -0500
Message-ID: <1359488798.8108.21.camel@jlt4.sipsolutions.net> (sfid-20130129_204621_281967_07BC9BB2)
Subject: Re: [PATCH v3] mac80211: dynamic short slot time for MBSSs
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Tue, 29 Jan 2013 20:46:38 +0100
In-Reply-To: <1359247195-25818-1-git-send-email-thomas@cozybit.com> (sfid-20130127_014059_015077_9ACDA848)
References: <1359247195-25818-1-git-send-email-thomas@cozybit.com>
	 (sfid-20130127_014059_015077_9ACDA848)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-01-26 at 16:39 -0800, Thomas Pedersen wrote:
> The standard mandates mesh STAs to set the ERP Short Slot
> Time capability info bit in beacons to 0. Even though this
> is their way of disallowing short slot time for mesh STAs,
> there should be no harm in enabling it if we determine all
> STAs in the current MBSS support ERP rates.
> 
> Increases throughput about 20% for legacy rates when
> enabled.

Applied.

johannes

