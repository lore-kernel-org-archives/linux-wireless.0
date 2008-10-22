Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:48364 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052AbYJVROF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 13:14:05 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2008 10:14:05 -0700
Date: Wed, 22 Oct 2008 03:13:59 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Zhu Yi <yi.zhu@intel.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Tomas Winkler <tomasw@gmail.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: New Regulatory Domain Api.
Message-ID: <20081022101359.GA6190@tesla> (sfid-20081022_191409_747666_4C032CE5)
References: <1224561748.24677.274.camel@debian.sh.intel.com> <43e72e890810202158m197b52a8y98844fdc9e1ccfd8@mail.gmail.com> <1224569252.9386.77.camel@californication> <43e72e890810202329g732a97ccxf176bdf4e035ccda@mail.gmail.com> <1224571890.9386.85.camel@californication> <20081021171328.GG17268@tuxdriver.com> <1224611033.9386.98.camel@californication> <20081021174800.GJ17268@tuxdriver.com> <20081021110203.GA8224@tesla> <1224667215.2917.75.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1224667215.2917.75.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 22, 2008 at 02:20:15AM -0700, Zhu Yi wrote:
> On Tue, 2008-10-21 at 04:02 -0700, Luis R. Rodriguez wrote:
> > This thread has about 65 messages on it, and no patches yet from
> > Intel.
> 
> Seems you jumped up when I offered a patch.
> http://marc.info/?l=linux-wireless&m=122455333027226&w=2

You complained about nobody willing to do foo, and yet I had already
provided a patch. That's what I "jumped" about.

> > I rather we talk productively about trying to resolve it with actual
> > code like Johannes or I am.
> 
> Good. See my patch on the other thread. The problem is also not the dual
> bands support. The regulatory framework should support hardware to do
> regulatory check and don't duplicate the work.

Huh? Hardware to do regulatory check? Now you really got me confused.

  Luis
