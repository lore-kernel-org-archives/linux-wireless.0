Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:38332 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbYJVJTo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 05:19:44 -0400
Subject: Re: New Regulatory Domain Api.
From: Zhu Yi <yi.zhu@intel.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Tomas Winkler <tomasw@gmail.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20081021110203.GA8224@tesla>
References: <1224554323.24677.248.camel@debian.sh.intel.com>
	 <43e72e890810201937l3be24156t2172590138fda132@mail.gmail.com>
	 <1224561748.24677.274.camel@debian.sh.intel.com>
	 <43e72e890810202158m197b52a8y98844fdc9e1ccfd8@mail.gmail.com>
	 <1224569252.9386.77.camel@californication>
	 <43e72e890810202329g732a97ccxf176bdf4e035ccda@mail.gmail.com>
	 <1224571890.9386.85.camel@californication>
	 <20081021171328.GG17268@tuxdriver.com>
	 <1224611033.9386.98.camel@californication>
	 <20081021174800.GJ17268@tuxdriver.com>  <20081021110203.GA8224@tesla>
Content-Type: text/plain
Date: Wed, 22 Oct 2008 17:20:15 +0800
Message-Id: <1224667215.2917.75.camel@debian.sh.intel.com> (sfid-20081022_111948_708494_0CEA0717)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-10-21 at 04:02 -0700, Luis R. Rodriguez wrote:
> This thread has about 65 messages on it, and no patches yet from
> Intel.

Seems you jumped up when I offered a patch.
http://marc.info/?l=linux-wireless&m=122455333027226&w=2

> I rather we talk productively about trying to resolve it with actual
> code like Johannes or I am.

Good. See my patch on the other thread. The problem is also not the dual
bands support. The regulatory framework should support hardware to do
regulatory check and don't duplicate the work.

Thanks,
-yi

