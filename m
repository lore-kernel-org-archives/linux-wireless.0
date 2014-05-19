Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33772 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbaESPAV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 11:00:21 -0400
Message-ID: <1400511606.4273.18.camel@jlt4.sipsolutions.net> (sfid-20140519_170024_652747_E9ADA747)
Subject: Re: [PATCHv3 2/4] cfg80211: export expected throughput via nl80211
 (GET_STATION)
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: b.a.t.m.a.n@lists.open-mesh.org, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Date: Mon, 19 May 2014 17:00:06 +0200
In-Reply-To: <1400344906-27984-3-git-send-email-antonio@meshcoding.com>
References: <1400344906-27984-1-git-send-email-antonio@meshcoding.com>
	 <1400344906-27984-3-git-send-email-antonio@meshcoding.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2014-05-17 at 18:41 +0200, Antonio Quartulli wrote:
> From: Antonio Quartulli <antonio@open-mesh.com>
> 
> Send the expected throughput when replying to a GET_STATION
> command via nl80211.

Since both are pretty short I think you might also just squash patches 1
and 2.

johannes

