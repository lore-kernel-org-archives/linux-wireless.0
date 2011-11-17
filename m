Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40497 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab1KQTam (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 14:30:42 -0500
Date: Thu, 17 Nov 2011 14:03:08 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Greg Dietsche <gregory.dietsche@cuw.edu>,
	linux-wireless@vger.kernel.org
Subject: Re: pull request: iwlegacy 2011-11-16
Message-ID: <20111117190307.GE32622@tuxdriver.com> (sfid-20111117_203045_703607_6644D70B)
References: <20111116122205.GA4409@redhat.com>
 <87y5vf8ak3.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87y5vf8ak3.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 17, 2011 at 09:36:44AM +0200, Kalle Valo wrote:
> Hi Stanislaw,
> 
> Stanislaw Gruszka <sgruszka@redhat.com> writes:
> 
> > Please pull iwlegacy cleanup changes done by Greg and me, intended
> > for 3.3. These request include huge patches with file renaming and
> > automatic code processing done by sed and indent. Driver is still
> > quite messy and need more cleanup, but these massive changes bring
> > driver close to the state that we could name it maintainable.
> >
> > Hopefully with having clean, maintainable code I will be able to fix
> > some nasty not easy reproducible bugs, we still have in the iwlegacy
> > driver.
> 
> I haven't seen these patches on linux-wireless mailing list at all.
> Isn't it recommended that all wireless patches are sent to
> linux-wireless for public review?

Yes, it is.  Please make sure to send these patches to the list for
review by the group.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
