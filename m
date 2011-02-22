Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:31968 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754677Ab1BVRg2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Feb 2011 12:36:28 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 22 Feb 2011 09:36:07 -0800
Date: Tue, 22 Feb 2011 23:06:03 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Sujith <m.sujith@gmail.com>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 12/23] ath9k_htc: Maintain individual counters for
 interfaces
Message-ID: <20110222173558.GA3779@vmraj-lnx.users.atheros.com>
References: <19809.52131.619464.414079@gargle.gargle.HOWL>
 <20110222050302.GA11916@vmraj-lnx.users.atheros.com>
 <19811.46111.864480.892504@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <19811.46111.864480.892504@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 22, 2011 at 06:33:27PM +0530, Sujith wrote:
> Rajkumar Manoharan wrote:
> > > +	if (priv->num_ibss_vif ||
> > > +	    (priv->nvifs && vif->type == NL80211_IFTYPE_ADHOC)) {
> > > +		ath_err(common, "IBSS coexistence with other modes is not allowed\n");
> > > +		mutex_unlock(&priv->mutex);
> > > +		return -ENOBUFS;
> > >  	}
> > Need to handle IBSS interface if vifs are already present.
> 
> I don't understand, addition of a new IBSS interface is denied if we
> already have an ADHOC interface present, or any other type, for that matter.
> This could be simplified, but this behavior might change in the future ...
>
Yeah. I misunderstood. 

--
Rajkumar
