Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:60939 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150Ab1DUOMw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 10:12:52 -0400
Subject: Re: updated iwlwifi 5000 uCode available
From: wwguy <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110421001615.GA2437@tuxdriver.com>
References: <1303316696.14995.162.camel@wwguy-huron>
	 <20110420182254.GE2737@tuxdriver.com> <20110420201124.GF2737@tuxdriver.com>
	 <1303330625.31956.1.camel@wwguy-ubuntu>
	 <20110421001615.GA2437@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Apr 2011 07:09:36 -0700
Message-ID: <1303394976.1507.1.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-04-20 at 17:16 -0700, John W. Linville wrote:
> On Wed, Apr 20, 2011 at 01:17:05PM -0700, wwguy wrote:
> > On Wed, 2011-04-20 at 13:11 -0700, John W. Linville wrote:
> > > On Wed, Apr 20, 2011 at 02:22:54PM -0400, John W. Linville wrote:
> > > > On Wed, Apr 20, 2011 at 09:24:56AM -0700, Guy, Wey-Yi wrote:
> > > > > Hi,
> > > > > 
> > > > > Due to a packaging error, we've re-released the 5000 uCode version
> > > > > 8.83.5.1. 
> > > > > 
> > > > > The updated version of firmware is available for download from
> > > > > http://intellinuxwireless.org/?n=Downloads
> > > > > 
> > > > > The old, wrongly packaged version has the following sha1sums:
> > > > > 
> > > > > bff3bfce6a31ad94be32b4c204ff8819b0cd03fd
> > > > > iwlwifi-5000-ucode-8.83.5.1.tgz
> > > > > 8d94177b509be3fb653ce8ba0c633244e4abf5f3
> > > > > iwlwifi-5000-ucode-8.83.5.1/iwlwifi-5000-5.ucode
> > > > 
> > > > The version I get from:
> > > > 
> > > > 	wget http://www.intellinuxwireless.org/iwlwifi/downloads/iwlwifi-5000-ucode-8.83.5.1.tgz
> > > > 
> > > > matches the sha1sum values listed above for the "wrongly packaged" version.
> > > > 
> > > > > The new version these:
> > > > > e70cc4b2249824a6b17ce9b9ae5087942c762213
> > > > > iwlwifi-5000-ucode-8.83.5.1.tgz
> > > > > 22bf6093ed8204027cc3207c739d2cab9cc92ea3
> > > > > iwlwifi-5000-ucode-8.83.5.1/iwlwifi-5000-5.ucode
> > > > > 
> > > > > The only change is removing the advertising for multiple interface
> > > > > support which is not actually present in this microcode.
> > > > > 
> > > > > Wey-Yi
> > > > 
> > > > So, you are going to release a different version of the file but
> > > > with the _same_ release number?  Couldn't you at least name it
> > > > iwlwifi-5000-ucode-8.83.5.1-1.tgz or something?
> > > 
> > > BTW, this name suggestions sucks...  8.83.5.1.1 or 8.83.5.2 would be
> > > better for packaging purposes (at least for RPM).
> > > 
> > this is really not an official build, so the build# stay the same. I am
> > ok to rename to anything, but the internal build# will not changed.
> 
> Which is the unofficial build?  The one that was previously released?
> Or the new one?  I am presuming that the one originally released is
> the "unofficial" one...
> 
> I appreciate your situation, but using the same release number for
> a new release (even if it is the "official" one) is a really bad
> release policy.  Just for your own sanity I would think that you
> would want a new release number -- even if you just did a rebuild
> and changed nothing but that number.
> 
Fully agree, I will ask for a new build and push it to URL. not sure it
can happen today, but I will try to make it happen before EOW

Thanks
Wey


