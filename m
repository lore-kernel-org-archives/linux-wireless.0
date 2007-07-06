Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761098AbXGFQD4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2007 12:03:56 -0400
Subject: Re: libertas (private) ioctls vs. nl80211
From: Dan Williams <dcbw@redhat.com>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, marcelo@kvack.org
In-Reply-To: <445f43ac0707060840k34d9554cta9ff11cad314db76@mail.gmail.com>
References: <1181757483.29767.99.camel@johannes.berg>
	 <20070614170901.GA13384@infradead.org>
	 <20070614103836.23b07a72.akpm@linux-foundation.org>
	 <20070614181307.GA16856@infradead.org>
	 <alpine.LFD.0.98.0706141121080.14121@woody.linux-foundation.org>
	 <20070614190936.GA28917@tuxdriver.com>
	 <445f43ac0707060840k34d9554cta9ff11cad314db76@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 06 Jul 2007 12:08:05 -0400
Message-Id: <1183738085.23402.2.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-07-06 at 08:40 -0700, Javier Cardona wrote:
> John,
> 
> On 6/14/07, John W. Linville <linville@tuxdriver.com> wrote:
> > I'm not aware of any project working on wireless mesh in mac80211 at
> > the moment, serious or otherwise.  I think one would be worthwhile,
> > but I don't know of anyone working on it.
> 
> We (cozybit Inc.) are working on an open implementation of 802.11s for
> Linux, based on mac80211.  We implemented an early draft
> implementation of 802.11s for the Marvell wireless interface used on
> the One Laptop Per Child.  That implementation was done entirely in
> firmware to take advantage of the unique capabilities of Marvell's
> wireless device:  the system-on-chip wireless module enables the
> laptop to act as a low-power, fully functional mesh point even when
> the main CPU is off.
> 
> Our next goal is to do a reference implementation of the latest
> 802.11s draft on Linux.  The hope is that it will help to achieve
> early interoperability and convergence of the standard.  We are
> seeking sponsors for the project.  So far Nortel has expressed strong
> interest.

Rock on.  If we can achieve convergence between the API that libertas
+mesh and the mac80211+mesh use, then we should both use the same
cfg80211/nl80211 interface for both.

Dan

> More details will follow soon.
> 
> Javier

