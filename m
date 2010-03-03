Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52343 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302Ab0CCTak (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 14:30:40 -0500
Date: Wed, 3 Mar 2010 14:29:46 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Subject: Re: [ipw3945-devel] iwl4965: 11a channels disabled in current
	wireless-testing
Message-ID: <20100303192946.GC23920@tuxdriver.com>
References: <201002281534.11656.helmut.schaa@googlemail.com> <201003022047.10196.helmut.schaa@googlemail.com> <1267640304.15761.121.camel@rchatre-DESK> <201003032008.47379.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <201003032008.47379.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 03, 2010 at 08:08:47PM +0100, Helmut Schaa wrote:
> Am Mittwoch 03 März 2010 schrieb reinette chatre:

> > $ iw reg get
> > country 00:
> > 	(2402 - 2472 @ 40), (3, 20)
> > 	(2457 - 2482 @ 20), (3, 20), PASSIVE-SCAN, NO-IBSS
> > 	(2474 - 2494 @ 20), (3, 20), NO-OFDM, PASSIVE-SCAN, NO-IBSS
> > 	(5170 - 5250 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
> > 	(5735 - 5835 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
> 
> Oops, that's what I get:
> 
> country 00:
>         (2402 - 2472 @ 40), (3, 20)
> 
> Luis, is the world reg domain encoded in cfg80211 or in the regdb? Maybe
> the regdb is too old or something like that?

Should be both -- start w/ the one encoded in the kernel and request
an update from userland if it is available.

Hth!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
