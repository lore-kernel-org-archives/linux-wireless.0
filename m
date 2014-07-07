Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49873 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaGGUPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2014 16:15:13 -0400
Date: Mon, 7 Jul 2014 16:08:06 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: pull request: iwlwifi-next 2014-07-06
Message-ID: <20140707200805.GD29650@tuxdriver.com> (sfid-20140707_221517_275734_ED5B6A6E)
References: <53B917DC.5050902@gmail.com>
 <53BAEAA4.1070000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53BAEAA4.1070000@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 07, 2014 at 09:44:52PM +0300, Emmanuel Grumbach wrote:
> 
> 
> On 07/06/2014 12:33 PM, Emmanuel Grumbach wrote:
> > Hi John,
> > 
> > This is a pull request intended for 3.17. Note that I merged wireless-next because of dependencies on mac80211.
> > I also merged iwlwifi-fixes to avoid conflicts.
> > 
> > Highlight here is the continuation of CSA by Andrei and Luca and Arik's work on TDLS - both are yet to be continued.
> > David has a new firmware API for Scan, and I add a new API for BT Coex. Along with that, the usual amount of work on new devices and fixes.
> > 
> > Please pull. Thanks!
> > 
> > The following changes since commit 15be8e89cdd999124a2307ffd6dacb895c3b802e:
> > 
> >   b43: add more bcma cores (2014-07-01 14:29:39 -0400)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git for-john
> > 
> > for you to fetch changes up to 0620b78632d4d3799d67ae846d30b3f07cba3862:
> I had to fixup one commit - new HEAD is 589a6ba46bdf9a4a4817fef011ff61905a1aa244.

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
