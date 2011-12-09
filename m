Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:48307 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab1LIR7Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Dec 2011 12:59:16 -0500
Subject: Re: [PATCH] iwlwifi regression in 20111205 merge
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Nikolay Martynov <mar.kolya@gmail.com>,
	"mar.kolya@gmail.com linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
In-Reply-To: <20111209165138.GB14236@tuxdriver.com>
References: <1323398619-19774-1-git-send-email-mar.kolya@gmail.com>
	 <1323399833.13074.80.camel@wwguy-huron>
	 <1323400528.13074.87.camel@wwguy-huron>
	 <20111209154415.GA14236@tuxdriver.com>
	 <1323443727.13074.91.camel@wwguy-huron>
	 <20111209165138.GB14236@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Dec 2011 09:00:35 -0800
Message-ID: <1323450035.13074.154.camel@wwguy-huron> (sfid-20111209_185919_679274_EF582C05)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-12-09 at 08:51 -0800, John W. Linville wrote:
> On Fri, Dec 09, 2011 at 07:15:27AM -0800, Guy, Wey-Yi wrote:
> > On Fri, 2011-12-09 at 07:44 -0800, John W. Linville wrote:
> > > Are the bits in the wireless tree correct?  If so, then please just
> > > send a patch to fix the wireless-next tree.
> > > 
> > > Now that the kernel.org mess is sorted, I guess we/I need to go back
> > > to pulling your trees instead of applying patches...
> > > 
> > "wireless" tree is correct, the piece is missing in iwl-mac80211.c on
> > "wireless-next" tree. Nikolay's patch fix it.
> > 
> > The question I have is what is the right way to deal with this. the
> > orig. patch need to be backport to stable, but the function was move to
> > different file short before the patch. That is the reason cause this
> > mess :-)
> 
> Once it has made it to Linus, you can send a patch for
> stable@vger.kernel.org referencing the commit ID in Linus' tree.
> 
> If you mean that the change needs to go to wireless but the function
> has moved in wireless-next, then post the patch for wireless.  Usually
> I can figure-out the merge (although apparently not in this case).
> If you think the merge will be tricky, you can send a reference patch
> for wireless-next for me to use as a guide when fixing-up the merge.
> Or you can pull your fixes tree into your -next tree, resolve the
> merge conflict, and ask me to pull.  Or you can wait until the merge
> breakage happens, and send a patch. :-)
> 

Thank you for the advise and I will try my best to make sure not happen
again :-)

Thanks
Wey



