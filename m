Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3288 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbXJKNLz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2007 09:11:55 -0400
Date: Thu, 11 Oct 2007 08:57:43 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] move wlan_*_association_work from header to c file
Message-ID: <20071011125743.GB27421@tuxdriver.com> (sfid-20071011_141203_163885_D98F44AA)
References: <200710111151.06989.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200710111151.06989.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please put "libertas: " at the beginning of your Subject lines...

No need to repost, I've got this one.

John

On Thu, Oct 11, 2007 at 11:51:06AM +0200, Holger Schurig wrote:
> Move wlan_postpone_association_work() and wlan_cancel_association_work()
> from a assoc.h file to the sole user, into wext.c.
> 
> In passing, rename the functions to libertas_XXX.
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
-- 
John W. Linville
linville@tuxdriver.com
