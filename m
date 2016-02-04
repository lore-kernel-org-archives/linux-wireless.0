Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44616 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965070AbcBDIxI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 03:53:08 -0500
Message-ID: <1454575981.2564.0.camel@sipsolutions.net> (sfid-20160204_095313_110205_424E2FBA)
Subject: Re: [PATCH v3 0/3] mac80211: add cleanup path for MPP table entries
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>, Henning Rogge <hrogge@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Date: Thu, 04 Feb 2016 09:53:01 +0100
In-Reply-To: <20160204033250.GA15719@localhost> (sfid-20160204_043255_042380_7C82E19A)
References: <1454504318-24988-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
	 <20160204033250.GA15719@localhost> (sfid-20160204_043255_042380_7C82E19A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-02-03 at 22:32 -0500, Bob Copeland wrote:
> On Wed, Feb 03, 2016 at 01:58:35PM +0100, Henning Rogge wrote:
> > Henning Rogge (3):
> >   mac80211: Remove MPP table entries with MPath
> >   mac80211: let unused MPP table entries timeout
> >   mac80211: Unify mesh and mpp path removal function
> > 
> >  net/mac80211/mesh_pathtbl.c | 102
> > +++++++++++++++++++++++++++++++++++++++-----
> >  net/mac80211/rx.c           |   1 +
> >  net/mac80211/tx.c           |   5 ++-
> >  3 files changed, 97 insertions(+), 11 deletions(-)
> 
> Thanks for the revisions.  For what it's worth, series:
> 
> Acked-by: Bob Copeland <me@bobcopeland.com>

All applied to mac80211-next, thanks.

johannes
