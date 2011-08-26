Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49422 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab1HZOaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 10:30:14 -0400
Date: Fri, 26 Aug 2011 10:27:04 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Javier Cardona <javier@cozybit.com>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/8] FIXUP: mesh gates
Message-ID: <20110826142704.GF2579@tuxdriver.com> (sfid-20110826_163018_425999_D212D580)
References: <1314235313-4564-1-git-send-email-thomas@cozybit.com>
 <87ei09onhi.fsf@purkki.adurom.net>
 <20110825114536.GA11153@tuxdriver.com>
 <CAPjQAd991sJkgNmpnKvANGAVx3KN6K4dpdt8WdZ2H=8MGYz-yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPjQAd991sJkgNmpnKvANGAVx3KN6K4dpdt8WdZ2H=8MGYz-yg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 25, 2011 at 11:30:53AM -0700, Javier Cardona wrote:
> On Thu, Aug 25, 2011 at 4:45 AM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > On Thu, Aug 25, 2011 at 12:21:29PM +0300, Kalle Valo wrote:
> >> Thomas Pedersen <thomas@cozybit.com> writes:
> >>
> >> > Since v1 of the mesh gate series was accidentally applied, revert
> >> > the relevant v1s and apply the v2s.
> >>
> >> This looks ugly in the git history. IMHO it would be cleaner that you
> >> would do a diff between series v1 and v2 and submit that as a proper
> >> patch.
> >>
> >> But John might think otherwise, better to wait for his comment.
> >
> > That is how I would prefer it as well.
> 
> As a general rule, should we treat patchsets sent to the list
> atomically?  I.e. if there are objections to a few patches in the set,
> should we resubmit a v2 of the whole patchset?
> (Before asking I tried to find that info here:
> http://linuxwireless.org/en/developers/Documentation/SubmittingPatches
> . I'll be happy to update the wiki with your response if you think
> it's relevant)

In general, I would prefer to see the entire patchset reposted --
that leads to less confusion for me.

Hth!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
