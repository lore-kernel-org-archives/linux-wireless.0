Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4501 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934884AbYEUA6l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 20:58:41 -0400
Date: Tue, 20 May 2008 17:31:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Pavel Roskin <proski@gnu.org>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
Subject: Re: [PATCH] libertas: remove lbs_get_data_rate()
Message-ID: <20080520213153.GA3188@tuxdriver.com> (sfid-20080521_025901_831504_0A6FE94E)
References: <200805141627.18368.hs4233@mail.mn-solutions.de> <1210784241.25598.1.camel@dv> <1211321319.21380.284.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1211321319.21380.284.camel@pmac.infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 20, 2008 at 11:08:39PM +0100, David Woodhouse wrote:
> On Wed, 2008-05-14 at 12:57 -0400, Pavel Roskin wrote:
> > On Wed, 2008-05-14 at 16:27 +0200, Holger Schurig wrote:
> > > lbs_get_data_rate() get's called, but no-one uses it's result.
> > 
> > s/'//g
> > 
> > Apostrophe overload :-)
> 
> When this got committed the g on the above was ignored...

True, sorry.

John
-- 
John W. Linville
linville@tuxdriver.com
