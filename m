Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:14918 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756221AbZCLRpm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 13:45:42 -0400
Subject: Re: [ipw3945-devel] [PATCH 3/8] iwl3945 : fix rate scaling
From: reinette chatre <reinette.chatre@intel.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1236824994.7177.3.camel@maxim-laptop>
References: <1236795481-12757-1-git-send-email-reinette.chatre@intel.com>
	 <1236795481-12757-2-git-send-email-reinette.chatre@intel.com>
	 <1236795481-12757-3-git-send-email-reinette.chatre@intel.com>
	 <1236795481-12757-4-git-send-email-reinette.chatre@intel.com>
	 <1236821360.9581.78.camel@maxim-laptop>
	 <1236824994.7177.3.camel@maxim-laptop>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 10:50:46 -0700
Message-Id: <1236880246.13699.17.camel@rc-desk> (sfid-20090312_184612_487503_D676FF4D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-03-11 at 19:29 -0700, Maxim Levitsky wrote:
> On Thu, 2009-03-12 at 03:29 +0200, Maxim Levitsky wrote:
> > On Wed, 2009-03-11 at 11:17 -0700, Reinette Chatre wrote:
> > > From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> > > 
> > > Patch fixes the bug 1900 at
> > > http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1900
> > > 
> > > Issues:
> > > Throughput and success ratio calculations were not done properly.
> > > Number of retries were exceeding 16.
> > 
> > ether.
> > 
> > On the other omitting  the 'disable_hw_scan=1' option (which appears to
> > work once again, since  few days ago it broke s2disk with hung scan) -
> 
> Ah , I remember now. The disable_hw_scan=0 breaks (!) 
> the rfkill support.

Could you please provide more details about this issue? We are
interested in steps to reproduce and logs you may have.

Thanks

Reinette


