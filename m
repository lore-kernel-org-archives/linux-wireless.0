Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46544 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354Ab3BSLK1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 06:10:27 -0500
Message-ID: <1361272223.8553.3.camel@jlt4.sipsolutions.net> (sfid-20130219_121033_805066_C407E35F)
Subject: Re: [PATCH 3.9] nl80211: remove radar channel information
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: simon.wunderlich@s2003.tu-chemnitz.de
Date: Tue, 19 Feb 2013 12:10:23 +0100
In-Reply-To: <1361227789-6892-1-git-send-email-johannes@sipsolutions.net> (sfid-20130218_234958_769230_A363FDE5)
References: <1361227789-6892-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130218_234958_769230_A363FDE5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-18 at 23:49 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The wiphy information is getting very close to being too
> much for a typical netlink dump message, and adding the
> two radar attributes to a number of channels can push it
> over the limit, which means userspace gets no information
> at all. Therefore, revert it for now. We're working on a
> solution that will allow userspace to request splitting
> the information across multiple netlink messages, which
> will allow us to add this back.

Applied.

johannes

