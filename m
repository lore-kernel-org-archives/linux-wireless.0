Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:43343 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbaLYQ7f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Dec 2014 11:59:35 -0500
Date: Thu, 25 Dec 2014 11:59:30 -0500
From: Kyle McMartin <kyle@infradead.org>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-firmware@kernel.org" <linux-firmware@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: firmware update for iwlwifi (3160 / 7260 / 7265)
Message-ID: <20141225165930.GA20646@merlin.infradead.org> (sfid-20141225_180232_577145_395142C7)
References: <1419148696.2316.7.camel@egrumbacBox>
 <1419148843.2316.8.camel@egrumbacBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1419148843.2316.8.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 21, 2014 at 08:00:42AM +0000, Grumbach, Emmanuel wrote:
> with the correct address of the linux firmware maintainers this time...
> 

;-) pulled. thanks Emmanuel.

regards, Kyle

> 
> On Sun, 2014-12-21 at 09:58 +0200, Emamnuel Grumbach wrote:
> > Dear Linux firmware maintainers,
> > 
> > Here is new release of the -10.ucode firmware for the following Intel
> > Wireless devices:
> > 3160 / 7260 / 7265 / 7265D
> > 
> > This release includes bug fixes only. We fix here firmware assertions
> > and association with buggy APs.
> > 
> > Please pull - thanks.
> > 
> > 
> > The following changes since commit
> > 38e5405c96d10bb42b629b45210c46166461fc21:
> > 
> >   cxgb4: Update firmware to revision 1.12.25.0 (2014-12-01 15:48:02
> > -0500)
> > 
> > are available in the git repository at:
> > 
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git
> > master
> > 
> > for you to fetch changes up to 571ad1ab9f6c85ba859387166f528a70ee1aa151:
> > 
> >   iwlwifi: update -10.ucode for 3160 / 7260 / 7265 / 7265D (2014-12-21
> > 09:52:07 +0200)
> > 
> > ----------------------------------------------------------------
> > Emmanuel Grumbach (1):
> >       iwlwifi: update -10.ucode for 3160 / 7260 / 7265 / 7265D
> > 
> >  WHENCE                 |   8 ++++----
> >  iwlwifi-3160-10.ucode  | Bin 610168 -> 610064 bytes
> >  iwlwifi-7260-10.ucode  | Bin 672480 -> 672372 bytes
> >  iwlwifi-7265-10.ucode  | Bin 736968 -> 736864 bytes
> >  iwlwifi-7265D-10.ucode | Bin 740636 -> 740456 bytes
> >  5 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/WHENCE b/WHENCE
> > index 44c41c7..df2dffa 100644
> > --- a/WHENCE
> > +++ b/WHENCE
> > @@ -816,7 +816,7 @@ File: iwlwifi-7260-9.ucode
> >  Version: 25.228.9.0
> >  
> >  File: iwlwifi-7260-10.ucode
> > -Version: 23.10.10.0
> > +Version: 23.11.10.0
> >  
> >  File: iwlwifi-3160-7.ucode
> >  Version: 22.1.7.0
> > @@ -828,7 +828,7 @@ File: iwlwifi-3160-9.ucode
> >  Version: 25.228.9.0
> >  
> >  File: iwlwifi-3160-10.ucode
> > -Version: 23.10.10.0
> > +Version: 23.11.10.0
> >  
> >  File: iwlwifi-7265-8.ucode
> >  Version: 22.24.8.0
> > @@ -837,10 +837,10 @@ File: iwlwifi-7265-9.ucode
> >  Version: 25.228.9.0
> >  
> >  File: iwlwifi-7265-10.ucode
> > -Version: 23.10.10.0
> > +Version: 23.11.10.0
> >  
> >  File: iwlwifi-7265D-10.ucode
> > -Version: 23.10.10.0
> > +Version: 23.11.10.0
> >  
> >  Licence: Redistributable. See LICENCE.iwlwifi_firmware for details
> >  
> > diff --git a/iwlwifi-3160-10.ucode b/iwlwifi-3160-10.ucode
> > index 8cec7bf..241bd4e 100644
> > Binary files a/iwlwifi-3160-10.ucode and b/iwlwifi-3160-10.ucode differ
> > diff --git a/iwlwifi-7260-10.ucode b/iwlwifi-7260-10.ucode
> > index 9e5b930..c7d8532 100644
> > Binary files a/iwlwifi-7260-10.ucode and b/iwlwifi-7260-10.ucode differ
> > diff --git a/iwlwifi-7265-10.ucode b/iwlwifi-7265-10.ucode
> > index 488ddd0..bda8dff 100644
> > Binary files a/iwlwifi-7265-10.ucode and b/iwlwifi-7265-10.ucode differ
> > diff --git a/iwlwifi-7265D-10.ucode b/iwlwifi-7265D-10.ucode
> > index 01194db..ebda04c 100644
> > Binary files a/iwlwifi-7265D-10.ucode and b/iwlwifi-7265D-10.ucode
> > differ
> > 
> 


