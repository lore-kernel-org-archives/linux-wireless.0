Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:33124 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab3EQMCE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 May 2013 08:02:04 -0400
Message-ID: <1368792118.14961.1.camel@jlt4.sipsolutions.net> (sfid-20130517_140208_446063_1CD6F6F1)
Subject: Re: [PATCH 3.10] mac80211: fix direct probe auth
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 17 May 2013 14:01:58 +0200
In-Reply-To: <20130517114303.GB1641@redhat.com>
References: <20130517114303.GB1641@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-05-17 at 13:43 +0200, Stanislaw Gruszka wrote:
> We send direct probe to broadcast address, as some APs do not respond to
> unicast PROBE frames when unassociated. Broadcast frames are not acked,
> so we can not use that for trigger MLME state machine, but we need to
> use old timeout mechanism.

Makes sense, applied.

johannes

