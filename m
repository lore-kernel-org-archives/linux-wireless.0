Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50056 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbYJOBpu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 21:45:50 -0400
Subject: Re: New Regulatory Domain Api.
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1223975972.10113.20.camel@johannes.berg>
References: <B27EBC40D200ED48A3F4CC2EBEABAE0B16C892F2@orsmsx501.amr.corp.intel.com>
	 <20081009154547.GB13349@tesla>
	 <1223608949.2510.1061.camel@debian.sh.intel.com>
	 (sfid-20081010_052512_883760_F373F92C)  <1223975972.10113.20.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 15 Oct 2008 09:40:56 +0800
Message-Id: <1224034856.24677.9.camel@debian.sh.intel.com> (sfid-20081015_034601_090856_B8650D74)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-10-14 at 03:19 -0600, Johannes Berg wrote:
> On Fri, 2008-10-10 at 11:22 +0800, Zhu Yi wrote:
> 
> > Does below scenario an expected behaviour?
> > 
> > 0. A system with iwl3945 BG card and iwl4965 AGN card.
> > 1. insmod iwl3945 -> regulatory_hint(, 99, rd) return 0;
> > 2. insmod iwl4965 -> regulatory_hint(, 99, rd2) return -EALREADY;
> > 3. iwl4965 has no A band support!
> 
> Yeah, I think this is expected, and the solution is to install crda and
> iw and set the regulatory domain manually to whatever country you're in
> rather than your cards SKU.

Let's use the solution at this time. Just a notion that the regdomain in
kernel doesn't sort out very well in some circumstance without user
intervention.

Thanks,
-yi

