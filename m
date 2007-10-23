Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41902 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbXJWIVd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2007 04:21:33 -0400
Subject: Re: [ipw3945-devel] iwl3945/mac80211 cannot connect to dynamic wep
	network
From: Zhu Yi <yi.zhu@intel.com>
To: dragoran <drago01@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <f6ca9fed0710230054i2b2849bfpc79c6090627b8625@mail.gmail.com>
References: <f6ca9fed0710230054i2b2849bfpc79c6090627b8625@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 23 Oct 2007 16:14:40 +0800
Message-Id: <1193127280.3069.261.camel@debian.sh.intel.com> (sfid-20071023_092137_044454_959EFCD3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 2007-10-23 at 09:54 +0200, dragoran wrote:
> I really have bo idea what this means... with ipw3945 (ieee80211
> based) the same network works just fine.

This is related to mac80211, not the driver. That's why ipw3945 works.
Does this patch work for you?

http://marc.info/?l=linux-wireless&m=118715117523167&w=2

Thanks,
-yi
