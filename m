Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46740 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbcHCG4G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2016 02:56:06 -0400
Message-ID: <1470207363.2638.11.camel@sipsolutions.net> (sfid-20160803_085611_043732_3F767AE8)
Subject: Re: [PATCH v2] mac80211: End the MPSP even if EOSP frame was not
 acked
From: Johannes Berg <johannes@sipsolutions.net>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi, me@bobcopeland.com
Date: Wed, 03 Aug 2016 08:56:03 +0200
In-Reply-To: <1470125817-4461-1-git-send-email-masashi.honma@gmail.com> (sfid-20160802_101724_465757_74C05B88)
References: <1468393475-2483-1-git-send-email-masashi.honma@gmail.com>
	 <1470125817-4461-1-git-send-email-masashi.honma@gmail.com>
	 (sfid-20160802_101724_465757_74C05B88)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-08-02 at 17:16 +0900, Masashi Honma wrote:
> If QoS frame with EOSP (end of service period) subfield=1 sent by
> local
> peer was not acked by remote peer, local peer did not end the MPSP.
> This
> prevents local peer from going to DOZE state. And if the remote peer
> goes away without closing connection, local peer continues AWAKE
> state
> and wastes battery.
> 
Applied, thanks.

johannes
