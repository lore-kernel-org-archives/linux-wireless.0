Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49111 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952Ab1DFOaS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 10:30:18 -0400
Date: Wed, 6 Apr 2011 10:27:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: new maintenance release of iwlwifi 1000 uCode available
Message-ID: <20110406142711.GB11941@tuxdriver.com>
References: <1301945671.14995.110.camel@wwguy-huron>
 <20110406141258.GA11941@tuxdriver.com>
 <1302099870.4090.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1302099870.4090.3.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 06, 2011 at 04:24:30PM +0200, Johannes Berg wrote:
> On Wed, 2011-04-06 at 10:12 -0400, John W. Linville wrote:
> > On Mon, Apr 04, 2011 at 12:34:31PM -0700, Guy, Wey-Yi wrote:
> > > Hi,
> > >         
> > >         Maintenance release version 39.31.5.1 of uCode for Intel 1000BGN
> > >         Series
> > >         WiFi Adapter is now available for download from
> > >         http://intellinuxwireless.org/?n=Downloads
> > >         
> > >         Changes:
> > >         - Fix "tid mismatch" issue
> > >         
> > >         Wey-Yi
> > 
> > Hmmm...the previous release was 128.50.3.1...  
> > 
> > I realize that the API portion advanced from 3.1 to 5.1, but the 
> > overall release number appears to be moving backwards.  Is this
> > intentional?
> 
> They're all over the place and basically random ... I *think* they
> depend on the branch it comes from internally, but I'm not even sure.

OK, I can cope.  But if you (i.e. your team) can influence them
towards a sane numbering scheme, it will probably make packagers
and/or release engineers happier in the distros...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
