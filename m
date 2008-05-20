Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39321 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170AbYETWIt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 18:08:49 -0400
Subject: Re: [PATCH] libertas: remove lbs_get_data_rate()
From: David Woodhouse <dwmw2@infradead.org>
To: Pavel Roskin <proski@gnu.org>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org
In-Reply-To: <1210784241.25598.1.camel@dv>
References: <200805141627.18368.hs4233@mail.mn-solutions.de>
	 <1210784241.25598.1.camel@dv>
Content-Type: text/plain
Date: Tue, 20 May 2008 23:08:39 +0100
Message-Id: <1211321319.21380.284.camel@pmac.infradead.org> (sfid-20080521_002157_000451_1A70686A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-05-14 at 12:57 -0400, Pavel Roskin wrote:
> On Wed, 2008-05-14 at 16:27 +0200, Holger Schurig wrote:
> > lbs_get_data_rate() get's called, but no-one uses it's result.
> 
> s/'//g
> 
> Apostrophe overload :-)

When this got committed the g on the above was ignored...

-- 
dwmw2

