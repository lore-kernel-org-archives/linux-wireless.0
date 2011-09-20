Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140Ab1ITHSe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 03:18:34 -0400
Date: Tue, 20 Sep 2011 09:18:13 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Greg Dietsche <greg@gregd.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: pull request: iwlegacy 2011-09-14
Message-ID: <20110920071813.GA2313@redhat.com> (sfid-20110920_091838_043710_B70D740D)
References: <20110914085900.GA2717@redhat.com>
 <20110919193122.GD2608@tuxdriver.com>
 <4E77C129.7070203@gregd.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E77C129.7070203@gregd.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 19, 2011 at 05:24:41PM -0500, Greg Dietsche wrote:
> On Mon, 19 Sep 2011 15:31:22 -0400, John W. Linville wrote:
> >On Wed, Sep 14, 2011 at 10:59:16AM +0200, Stanislaw Gruszka wrote:
> >>John,
> >>
> >>Please pull iwlegacy cleanup changes done by Greg and me, intended
> >>for 3.2. These request include huge patches with file renaming and
> >>automatic code processing done by sed and indent. Work of changing
> >>iwlegacy driver into something that I could consider maintainable
> >>is not done yet, but these massive changes bring closer into that.
> >>Hopefully with having clean, maintainable code I will be able to
> >>fix some nasty, not easy reproducible bugs, we still have in the
> >>iwlegacy driver.
> >>
> >>Thanks.
> >>
> >>The following changes since commit
> >>d82cdad64a0127611724c61849a8487d69fb76ef:
> >>
> >>  Merge branch 'master' of
> >>git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next
> >>(2011-08-30 16:34:33 -0400)
> >>
> >>are available in the git repository at:
> >>
> >>  git://github.com/dietsche/linux.git
> >>wireless-next-iwlegacy-stanislaw-greg
> >
> >It looks like you pulled something other than wireless-next into this
> >tree.  If you want me to pull directly, then you need to based your
> >tree (or at least the branch I'm pulling) on wireless-next
> >exclusively.
> 
> Sorry for the confusing branch name! I was naming it based on which
> kernel release the code is for and not where it was branched from.
> Also, I hadn't anticipated that my git tree might end up in pull
> request...
> 
> The branch wireless-next-iwlegacy-stanislaw-greg is based on John's
> wireless-testing tree. Looking at previous emails in this thread, we
> referred to wireless-testing as the base for the changes, so
> branching from wireless-testing was done on purpose.
> 
> I briefly tried to apply the patch set to wireless-next, but it
> doesn't like Stanislaw's second patch (rename iwl to il). So some
> work will need to be done if we really need to pull into
> wireless-next.

I will setup wireless-next based tree on github. I'll need it anyway
for future changes.

Thanks
Stanislaw
