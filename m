Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbXJWOIG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2007 10:08:06 -0400
Subject: Re: [ipw3945-devel] iwl3945/mac80211 cannot connect to dynamic wep
	network
From: Dan Williams <dcbw@redhat.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: dragoran <drago01@gmail.com>, linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1193127280.3069.261.camel@debian.sh.intel.com>
References: <f6ca9fed0710230054i2b2849bfpc79c6090627b8625@mail.gmail.com>
	 <1193127280.3069.261.camel@debian.sh.intel.com>
Content-Type: text/plain
Date: Tue, 23 Oct 2007 10:07:33 -0400
Message-Id: <1193148453.8648.20.camel@localhost.localdomain> (sfid-20071023_150810_118446_E87EE8F5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-10-23 at 16:14 +0800, Zhu Yi wrote:
> On Tue, 2007-10-23 at 09:54 +0200, dragoran wrote:
> > I really have bo idea what this means... with ipw3945 (ieee80211
> > based) the same network works just fine.
> 
> This is related to mac80211, not the driver. That's why ipw3945 works.
> Does this patch work for you?
> 
> http://marc.info/?l=linux-wireless&m=118715117523167&w=2

Was there ever a conclusion to this patch?  ISTR it went through a
couple comments and was more or less rejected as the wrong approach.
Can anyone comment as to what the _right_ approach is?  Not being able
to connect to dynamic WEP networks is not acceptable, what needs to be
done to make this work?

Thanks,
Dan


