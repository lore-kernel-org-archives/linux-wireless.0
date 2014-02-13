Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38541 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaBMOpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 09:45:22 -0500
Date: Thu, 13 Feb 2014 09:44:11 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [Ilw] Re: pull request: iwlwifi-next 2014-02-03
Message-ID: <20140213144411.GH22203@tuxdriver.com> (sfid-20140213_154534_522163_3D89ED9C)
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
 <20140212202700.GF22203@tuxdriver.com>
 <0BA3FCBA62E2DC44AF3030971E174FB303D66EDF@HASMSX103.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB303D66EDF@HASMSX103.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 13, 2014 at 07:10:05AM +0000, Grumbach, Emmanuel wrote:
> > >
> > > git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
> > > for-john
> > >
> > > for you to fetch changes up to
> > 8e305d171ab58dbd79ad8e13d93db2237fde5749:
> > >
> > >   iwlwifi: mvm: remove duplicate assignment to ap_ibss_active
> > > (2014-02-03 22:43:53 +0200)
> > 
> > Pulling now...
> > 
> 
> Apparently, you pulled master branch instead of for-john branch. Not a big deal for me, you just saved me a bit of work :)

Yeah, OK.  I have to watch-out for that a lot -- your pull requests
typically have a line break before the "for-john" (as shown in the
quoted bits above).  If possible, it would be helpful if you could
look for that and make sure that that line is contiguous...thanks!

Since it is still early in the release, maybe I should rebase
wireless-next to correct for this?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
