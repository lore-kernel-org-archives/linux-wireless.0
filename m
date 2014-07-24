Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32982 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbaGXK6t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 06:58:49 -0400
Message-ID: <1406199521.14675.13.camel@jlt4.sipsolutions.net> (sfid-20140724_125852_823480_37C113CF)
Subject: Re: [PATCH 1/2] mac80211: mesh_plink: handle confirm frames with
 new plid
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: devel@lists.open80211s.org, linux-wireless@vger.kernel.org
Date: Thu, 24 Jul 2014 12:58:41 +0200
In-Reply-To: <20140628205414.GA17825@localhost> (sfid-20140628_225418_043916_0596D325)
References: <1403987726-17576-1-git-send-email-me@bobcopeland.com>
	 <20140628205414.GA17825@localhost> (sfid-20140628_225418_043916_0596D325)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2014-06-28 at 16:54 -0400, Bob Copeland wrote:
> [oops, +linux-wireless]
> On Sat, Jun 28, 2014 at 04:35:25PM -0400, Bob Copeland wrote:
> > The 802.11 standard says when processing a plink confirm
> > frame:
> > 
> > "If the peerLinkID in the mesh peering instance has not been
> > set, the Local Link ID field of the Mesh Peering Confirm
> > request shall be copied into the peerLinkID in the mesh
> > peering instance."
> > 
> > We were only doing this when receiving an open peering frame,
> > but it could happen that the open frame gets lost and so we
> > should handle this case rather than rejecting the confirm and
> > failing the whole peering process.

Applied.

johannes

