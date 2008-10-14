Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55756 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbYJNVxn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 17:53:43 -0400
Date: Tue, 14 Oct 2008 17:50:50 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Zhu Yi <yi.zhu@intel.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: New Regulatory Domain Api.
Message-ID: <20081014215050.GG3349@tuxdriver.com> (sfid-20081014_235348_909442_2F9A2967)
References: <1223608949.2510.1061.camel@debian.sh.intel.com> <43e72e890810100949i78c1d813x1b66c6bc0239ef28@mail.gmail.com> <1223967581.2570.144.camel@debian.sh.intel.com> <43e72e890810140004k6bfa72edsf39acbafcf317fa6@mail.gmail.com> <1223969808.2570.153.camel@debian.sh.intel.com> <43e72e890810140204ne135e72kefe379dd3d26f7bc@mail.gmail.com> <20081014203510.GD3349@tuxdriver.com> <1224018957.3027.9.camel@johannes.berg> <20081014211912.GF3349@tuxdriver.com> <1224019662.3027.13.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1224019662.3027.13.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 14, 2008 at 11:27:42PM +0200, Johannes Berg wrote:
> On Tue, 2008-10-14 at 17:19 -0400, John W. Linville wrote:

> > Should there be an "I make no representation of authority" flag in
> > the regulatory maps?
> 
> The only reasonable solution I can come up with is have it make separate
> hints for 2.4 and 5 GHz and then a single-band card won't say anything
> about 5 GHz so the dual-band gets to set that part. But OTOH I don't see
> a reasonable use-case for this whole thing so far---we really only added
> this after discussions with Marcel at OLS so embedded systems can
> function w/o crda, but who would build an embedded system with two
> different cards like that?

And couldn't such a person also do the equivalent of the OLD_REGULATORY
stuff that we have now?

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
