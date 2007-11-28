Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:38267 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbXK1PCO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 10:02:14 -0500
Subject: Re: [PATCH] less eventcause shifts
From: David Woodhouse <dwmw2@infradead.org>
To: Dan Williams <dcbw@redhat.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org
In-Reply-To: <1196261611.28264.0.camel@localhost.localdomain>
References: <200711280915.11300.hs4233@mail.mn-solutions.de>
	 <1196261611.28264.0.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 28 Nov 2007 15:02:09 +0000
Message-Id: <1196262129.30806.26.camel@pmac.infradead.org> (sfid-20071128_150216_687214_E56C462B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 2007-11-28 at 09:53 -0500, Dan Williams wrote:
> On Wed, 2007-11-28 at 09:15 +0100, Holger Schurig wrote:
> > * only shift eventcause once
> > 
> > * convert mac events to decimal, as this is what the firmware
> >   manual uses in section 6.1, too
> > 
> > Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
> 
> Acked-by: Dan Williams <dcbw@redhat.com>

s/less/fewer/ of course :)

Since I'm also going to be sending a flurry of libertas patches and the
turnaround through the wireless tree seems suboptimal, shall we put up a
git tree and work on it together, then ask John to pull when we're done?

-- 
dwmw2

