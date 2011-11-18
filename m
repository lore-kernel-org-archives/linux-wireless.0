Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab1KRH3D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 02:29:03 -0500
Date: Fri, 18 Nov 2011 08:30:42 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Kalle Valo <kvalo@adurom.com>,
	Greg Dietsche <gregory.dietsche@cuw.edu>,
	linux-wireless@vger.kernel.org
Subject: Re: pull request: iwlegacy 2011-11-16
Message-ID: <20111118073041.GA2203@redhat.com> (sfid-20111118_082906_898160_765D0389)
References: <20111116122205.GA4409@redhat.com>
 <87y5vf8ak3.fsf@purkki.adurom.net>
 <20111117190307.GE32622@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20111117190307.GE32622@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 17, 2011 at 02:03:08PM -0500, John W. Linville wrote:
> On Thu, Nov 17, 2011 at 09:36:44AM +0200, Kalle Valo wrote:
> > Stanislaw Gruszka <sgruszka@redhat.com> writes:
> > 
> > > Please pull iwlegacy cleanup changes done by Greg and me, intended
> > > for 3.3. These request include huge patches with file renaming and
> > > automatic code processing done by sed and indent. Driver is still
> > > quite messy and need more cleanup, but these massive changes bring
> > > driver close to the state that we could name it maintainable.
> > >
> > > Hopefully with having clean, maintainable code I will be able to fix
> > > some nasty not easy reproducible bugs, we still have in the iwlegacy
> > > driver.
> > 
> > I haven't seen these patches on linux-wireless mailing list at all.

I did not post them because most of them are big patches done by sed or
"git mv", nothing that would benefit from review.

> > Isn't it recommended that all wireless patches are sent to
> > linux-wireless for public review?
>
> Yes, it is.  Please make sure to send these patches to the list for
> review by the group.

I'm going to post, but first I'll need to separate big patches and make
them available for download instead of posting mega bytes in email.

Anyway, if someone like to look at the patches, its better to just pull
github tree, or even clone it. It used with --reference option clone
will be fast, i.e:

git clone --reference linux-2.6  git://github.com/sgruszka/iwlegacy.git

Stanislaw
