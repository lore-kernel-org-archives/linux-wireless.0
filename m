Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbZLPQvP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2009 11:51:15 -0500
Subject: Re: [PATCH 17/19] [RFC, v2] libertas: Kconfig entry for
 libertas+cfg80211
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <holgerschurig@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <200912151558.48844.holgerschurig@gmail.com>
References: <20091022133043.185554096@mail.mn-solutions.de>
	 <1256587966.2110.28.camel@localhost.localdomain>
	 <200912151544.00402.hs4233@mail.mn-solutions.de>
	 <200912151558.48844.holgerschurig@gmail.com>
Content-Type: text/plain
Date: Wed, 16 Dec 2009 08:51:06 -0800
Message-Id: <1260982266.2179.6.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-12-15 at 15:58 +0100, Holger Schurig wrote:
> > This means that STA/IBSS and Libertas' MESH cannot be active at 
> > the same time.
> 
> Oh, just read the old wext.c and I was wrong.
> 
> This magic de-auth / ibss leave happens only if the mesh channel 
> is different from the current STA/IBSS channel.

Yes; STA and lbs-mesh can be active at the same time; that's how the
device becomes a "Mesh portal" and essentially bridges the mesh network
to an actual internet connection.

Dan


