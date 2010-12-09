Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:64388 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426Ab0LIGbp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 01:31:45 -0500
Subject: Re: [PATCH 2/3] iwlagn: implement layout-agnostic EEPROM reading
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Berg, Johannes" <johannes.berg@intel.com>
In-Reply-To: <20101209014850.GA2915@tuxdriver.com>
References: <1291743428-19642-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1291743428-19642-3-git-send-email-wey-yi.w.guy@intel.com>
	 <20101207192806.GF2700@tuxdriver.com>
	 <1291751118.20668.8.camel@wwguy-ubuntu>
	 <20101208201926.GF2423@tuxdriver.com>
	 <1291851191.10280.174.camel@wwguy-ubuntu>
	 <20101209014850.GA2915@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 08 Dec 2010 22:30:38 -0800
Message-Id: <1291876238.10280.176.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-08 at 17:48 -0800, John W. Linville wrote:
> On Wed, Dec 08, 2010 at 03:33:11PM -0800, Guy, Wey-Yi wrote:
> > On Wed, 2010-12-08 at 12:19 -0800, John W. Linville wrote:
> > > On Tue, Dec 07, 2010 at 11:45:18AM -0800, Guy, Wey-Yi wrote:
> 
> > > > So it is really judgment call, we plan to release both 6005 and 6030
> > > > uCode in the next few weeks and hardware should be on the market early
> > > > next year. If by the time when hardware become available, distro already
> > > > move to .38, then I am ok with it. What you think?
> > > 
> > > What about a patch to disable those devices in 2.6.37, and leave the
> > > existing EEPROM code alone for that release?
> > > 
> > 
> > I don't think it is an option to disable all the new devices for .37
> > since we commit to support them in .37 kernel, 
> 
> It certainly is an option.  Missing hardware support for one release
> versus potentially destabilizing all existing iwlwifi users seems
> like an obvious trade-off to me.  I trust Johannes, of course, but
> we all make subtle mistakes from time to time.
> 
> > How about re-work the patch to keep the orig. EEPROM reading method for
> > older devices, but using new EEPROM method for the newer devices
> > (6005/6030/...). it that work for .37 kernel?
> 
> I suppose this could work, although it sounds like an even bigger
> patch.  I guess we would need to see the patch.
> 
as matter as fact, I think the patch will be smaller since the old code
will not be removed. I will ask Johannes to rework the patch and see if
it works for you

Thanks
Wey

