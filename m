Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57642 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbYJNUh5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 16:37:57 -0400
Date: Tue, 14 Oct 2008 16:35:10 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Zhu Yi <yi.zhu@intel.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: New Regulatory Domain Api.
Message-ID: <20081014203510.GD3349@tuxdriver.com> (sfid-20081014_223802_063949_1D8CE891)
References: <B27EBC40D200ED48A3F4CC2EBEABAE0B16C892F2@orsmsx501.amr.corp.intel.com> <20081009154547.GB13349@tesla> <1223608949.2510.1061.camel@debian.sh.intel.com> <43e72e890810100949i78c1d813x1b66c6bc0239ef28@mail.gmail.com> <1223967581.2570.144.camel@debian.sh.intel.com> <43e72e890810140004k6bfa72edsf39acbafcf317fa6@mail.gmail.com> <1223969808.2570.153.camel@debian.sh.intel.com> <43e72e890810140204ne135e72kefe379dd3d26f7bc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890810140204ne135e72kefe379dd3d26f7bc@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 14, 2008 at 02:04:50AM -0700, Luis R. Rodriguez wrote:

> The question which I thought was being asked was if you have two cards
> present, one a dual band card 2.4 GHz and 5 GHz and another a single
> band 2.4 GHz card what happens in terms of regulatory rules. What I'm
> suggesting should happen is the intersection of their regulatory rules
> should be applied and in this case only the 2.4 GHz channels that work
> on both cards should be used. What currently happens is the regulatory
> rules of the first card detected takes effect.

That doesn't sound like quite the correct behavior.  If a channel is
excluded for regulatory reasons, then I suspect that should govern
everyone.  But if one card just doesn't support a band, I don't see
why any other cards should be limited by that.

Did I miss something?

John

-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
