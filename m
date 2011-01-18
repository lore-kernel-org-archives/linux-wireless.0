Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50171 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab1ARNvW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 08:51:22 -0500
Subject: Re: [RFC] mac80211: reset connection poll on receiving unicast
 data frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1295358285-9336-1-git-send-email-rmanoharan@atheros.com>
References: <1295358285-9336-1-git-send-email-rmanoharan@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 14:51:20 +0100
Message-ID: <1295358680.3563.21.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-18 at 19:14 +0530, Rajkumar Manoharan wrote:
> In noisy channel conditions, some APs do not reply to probe
> requests which results in STA disconnection. It is perfectly
> fine to reset the connection polling if unicast frames are
> received from that AP properly.

I'm not convinced. We often have no trouble hearing the AP but the AP
isn't hearing us because sensitivity is different etc.

johannes

