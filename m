Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:32916 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993Ab1DTUPl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 16:15:41 -0400
Date: Wed, 20 Apr 2011 16:11:24 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: updated iwlwifi 5000 uCode available
Message-ID: <20110420201124.GF2737@tuxdriver.com>
References: <1303316696.14995.162.camel@wwguy-huron>
 <20110420182254.GE2737@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110420182254.GE2737@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 20, 2011 at 02:22:54PM -0400, John W. Linville wrote:
> On Wed, Apr 20, 2011 at 09:24:56AM -0700, Guy, Wey-Yi wrote:
> > Hi,
> > 
> > Due to a packaging error, we've re-released the 5000 uCode version
> > 8.83.5.1. 
> > 
> > The updated version of firmware is available for download from
> > http://intellinuxwireless.org/?n=Downloads
> > 
> > The old, wrongly packaged version has the following sha1sums:
> > 
> > bff3bfce6a31ad94be32b4c204ff8819b0cd03fd
> > iwlwifi-5000-ucode-8.83.5.1.tgz
> > 8d94177b509be3fb653ce8ba0c633244e4abf5f3
> > iwlwifi-5000-ucode-8.83.5.1/iwlwifi-5000-5.ucode
> 
> The version I get from:
> 
> 	wget http://www.intellinuxwireless.org/iwlwifi/downloads/iwlwifi-5000-ucode-8.83.5.1.tgz
> 
> matches the sha1sum values listed above for the "wrongly packaged" version.
> 
> > The new version these:
> > e70cc4b2249824a6b17ce9b9ae5087942c762213
> > iwlwifi-5000-ucode-8.83.5.1.tgz
> > 22bf6093ed8204027cc3207c739d2cab9cc92ea3
> > iwlwifi-5000-ucode-8.83.5.1/iwlwifi-5000-5.ucode
> > 
> > The only change is removing the advertising for multiple interface
> > support which is not actually present in this microcode.
> > 
> > Wey-Yi
> 
> So, you are going to release a different version of the file but
> with the _same_ release number?  Couldn't you at least name it
> iwlwifi-5000-ucode-8.83.5.1-1.tgz or something?

BTW, this name suggestions sucks...  8.83.5.1.1 or 8.83.5.2 would be
better for packaging purposes (at least for RPM).

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
