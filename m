Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40046 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbcHBIbO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 04:31:14 -0400
Message-ID: <1470124071.2665.12.camel@sipsolutions.net> (sfid-20160802_103120_925364_205B80C9)
Subject: Re: [PATCH] mac80211: End the MPSP even if EOSP frame was not
 received
From: Johannes Berg <johannes@sipsolutions.net>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi, me@bobcopeland.com
Date: Tue, 02 Aug 2016 09:47:51 +0200
In-Reply-To: <1468393475-2483-1-git-send-email-masashi.honma@gmail.com> (sfid-20160713_090449_060534_47A31585)
References: <1468393475-2483-1-git-send-email-masashi.honma@gmail.com>
	 (sfid-20160713_090449_060534_47A31585)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-07-13 at 16:04 +0900, Masashi Honma wrote:
> The mesh STA sends QoS frame with EOSP (end of service period)
> subfiled=1 to end the MPSP(mesh peer service period). Previously, if
> the frame was not acked by peer, the mesh STA did not end the MPSP.
> This patch ends the MPSP even if the QoS frame was no acked.
> 
Can you elaborate why? Does it fix anything? Please resend the patch
with that (and perhaps the "subfield" typo fixed above).

johannes
