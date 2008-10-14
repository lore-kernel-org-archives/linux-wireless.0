Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54814 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbYJNVWI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 17:22:08 -0400
Date: Tue, 14 Oct 2008 17:19:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Zhu Yi <yi.zhu@intel.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: New Regulatory Domain Api.
Message-ID: <20081014211912.GF3349@tuxdriver.com> (sfid-20081014_232245_065685_30E4188B)
References: <B27EBC40D200ED48A3F4CC2EBEABAE0B16C892F2@orsmsx501.amr.corp.intel.com> <20081009154547.GB13349@tesla> <1223608949.2510.1061.camel@debian.sh.intel.com> <43e72e890810100949i78c1d813x1b66c6bc0239ef28@mail.gmail.com> <1223967581.2570.144.camel@debian.sh.intel.com> <43e72e890810140004k6bfa72edsf39acbafcf317fa6@mail.gmail.com> <1223969808.2570.153.camel@debian.sh.intel.com> <43e72e890810140204ne135e72kefe379dd3d26f7bc@mail.gmail.com> <20081014203510.GD3349@tuxdriver.com> <1224018957.3027.9.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1224018957.3027.9.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 14, 2008 at 11:15:57PM +0200, Johannes Berg wrote:
> On Tue, 2008-10-14 at 16:35 -0400, John W. Linville wrote:
> 
> > That doesn't sound like quite the correct behavior.  If a channel is
> > excluded for regulatory reasons, then I suspect that should govern
> > everyone.  But if one card just doesn't support a band, I don't see
> > why any other cards should be limited by that.
> > 
> > Did I miss something?
> 
> Well, the thing is that the iwlwifi drivers pretend to know the
> regulatory domain; thus when a single-band card registers the regulatory
> domain, it gets set to just a domain with the single band.

Ah, now I see what this is about...thanks!

Should there be an "I make no representation of authority" flag in
the regulatory maps?

-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
