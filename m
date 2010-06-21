Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34690 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab0FUPAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 11:00:13 -0400
Date: Mon, 21 Jun 2010 10:57:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Green <Michael.Green@Atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	David Quan <David.Quan@Atheros.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>
Subject: Re: wireless-regdb: Add A band in IL - And general point regarding
 tx power limits in the dbase
Message-ID: <20100621145740.GC5332@tuxdriver.com>
References: <1274856569-13436-1-git-send-email-emmanuel.grumbach@intel.com>
 <20100618184257.GB6282@tuxdriver.com>
 <AANLkTimN8oZ63m7cp2lE5MuFiEJ8iAGKswKIENTjIhMg@mail.gmail.com>
 <93781E992CBA7843962D8B0E7D683F3C1172BD0B6D@SC1EXMB-MBCL.global.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <93781E992CBA7843962D8B0E7D683F3C1172BD0B6D@SC1EXMB-MBCL.global.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 21, 2010 at 07:51:56AM -0700, Michael Green wrote:
> Here are my comments on the proposed patch...
> 
> country IL:
> > >       (2402 - 2482 @ 40), (N/A, 20)
> > > +     (5150 - 5250 @ 40). (N/A, 200 mW), NO-OUTDOOR
> > > +     (5250 - 5350 @ 40). (N/A, 200 mW), NO-OUTDOOR, DFS

> b) I think all entries in the dbase should be in dBm (not mW).
> dBm vs. mW are absolutely equivalent. No reason to retain "mW"
> unit from the source docs.  I think this was agreed by all before,
> but wanted to reiterate.

I'm not sure I see the fuss.  If anything, using the same units as
the source docs seems less error-prone to me.  Why not stick with
the source units and let the tool do the conversion rather than risk
introducing an error in the manual conversion?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
