Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45073 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbaBMOtO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 09:49:14 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Emmanuel Grumbach <egrumbach@gmail.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [Ilw] Re: pull request: iwlwifi-next 2014-02-03
Date: Thu, 13 Feb 2014 14:48:30 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303D67605@HASMSX103.ger.corp.intel.com> (sfid-20140213_154923_302755_995E2952)
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
 <20140212202700.GF22203@tuxdriver.com>
 <0BA3FCBA62E2DC44AF3030971E174FB303D66EDF@HASMSX103.ger.corp.intel.com>
 <20140213144411.GH22203@tuxdriver.com>
In-Reply-To: <20140213144411.GH22203@tuxdriver.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> On Thu, Feb 13, 2014 at 07:10:05AM +0000, Grumbach, Emmanuel wrote:
> > > >
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
> > > > .git
> > > > for-john
> > > >
> > > > for you to fetch changes up to
> > > 8e305d171ab58dbd79ad8e13d93db2237fde5749:
> > > >
> > > >   iwlwifi: mvm: remove duplicate assignment to ap_ibss_active
> > > > (2014-02-03 22:43:53 +0200)
> > >
> > > Pulling now...
> > >
> >
> > Apparently, you pulled master branch instead of for-john branch. Not a
> > big deal for me, you just saved me a bit of work :)
> 
> Yeah, OK.  I have to watch-out for that a lot -- your pull requests typically
> have a line break before the "for-john" (as shown in the quoted bits above).
> If possible, it would be helpful if you could look for that and make sure that
> that line is contiguous...thanks!

Ok - I guess I'll have to check my wrapping settings in Thunderbird which seem to make trouble with Enigmail - but maybe not in platintext?
Will check.

> 
> Since it is still early in the release, maybe I should rebase wireless-next to
> correct for this?
> 

Not at all - wireless-next is fine as is.
BTW - for my -fixes pull request I just sent, I left "master" by mistake, but I don't have anything in pipe for -fixes anyway - so I don't think that I will have a diff between for-john and master anytime soon.

> John
> --
> John W. Linville		Someday the world will need a hero, and you
> linville@tuxdriver.com			might be all we have.  Be ready.
