Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:42708 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbXLDPVm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 10:21:42 -0500
Subject: Re: [PATCH] less eventcause shifts
From: David Woodhouse <dwmw2@infradead.org>
To: Dan Williams <dcbw@redhat.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org
In-Reply-To: <1196780805.26155.29.camel@localhost.localdomain>
References: <200711280915.11300.hs4233@mail.mn-solutions.de>
	 <1196704681.21151.13.camel@localhost.localdomain>
	 <1196714939.13978.171.camel@pmac.infradead.org>
	 <20071204145437.GC19911@tuxdriver.com>
	 <1196780866.13978.275.camel@pmac.infradead.org>
	 <1196780805.26155.29.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 15:21:36 +0000
Message-Id: <1196781696.13978.288.camel@pmac.infradead.org> (sfid-20071204_152205_999396_D1610140)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 2007-12-04 at 10:06 -0500, Dan Williams wrote:
> Those patches should get into 2.6.25; I don't want them held up if you
> don't think you can get the command rework done by 2.6.25...  As long as
> the stuff that's queued up in John's tree gets up to Linus for 2.6.25,
> then you can develop however you want in libertas-2.6 based of Linus or
> whatever.

I intend to have the command rework done by the end of the week. And if
there's anything in libertas-2.6 which isn't ready to go by the time the
merge window opens, I promise I'll cherry-pick the bits which _are_
ready to go, so that they're not held up.

-- 
dwmw2

