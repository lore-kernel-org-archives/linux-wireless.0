Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53641 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758076Ab3FCOyT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 10:54:19 -0400
Message-ID: <1370271255.8227.11.camel@jlt4.sipsolutions.net> (sfid-20130603_165433_652776_81490D0E)
Subject: Re: [PATCH] mac80211: don't check local mesh TTL on TX
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Date: Mon, 03 Jun 2013 16:54:15 +0200
In-Reply-To: <1370047307-19248-1-git-send-email-thomas@cozybit.com> (sfid-20130601_024412_047786_9A024F46)
References: <1370047307-19248-1-git-send-email-thomas@cozybit.com>
	 (sfid-20130601_024412_047786_9A024F46)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-05-31 at 17:41 -0700, Thomas Pedersen wrote:
> nl80211 has already verified the mesh TTL on setting the
> mesh config, so no need to check it again in mac80211.

makes sense, applied.

johannes

