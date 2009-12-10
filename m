Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59349 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760971AbZLJQaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2009 11:30:11 -0500
Date: Thu, 10 Dec 2009 11:25:18 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org,
	davem@davemloft.net
Subject: Re: Revised wireless tree management practices
Message-ID: <20091210162517.GD2955@tuxdriver.com>
References: <20091209211054.GB32058@tuxdriver.com> <87ljhb0x0h.fsf@purkki.valot.fi> <20091210134733.GC11112@tuxdriver.com> <87ein30vt4.fsf@purkki.valot.fi> <43e72e890912100631if1c17b2l597168813db4a19c@mail.gmail.com> <20091210143754.GA2955@tuxdriver.com> <43e72e890912100653p3890705u4f88dd19026a5877@mail.gmail.com> <20091210150318.GB2955@tuxdriver.com> <43e72e890912100814u45a58c47j5dfd66769f8170b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <43e72e890912100814u45a58c47j5dfd66769f8170b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 10, 2009 at 08:14:34AM -0800, Luis R. Rodriguez wrote:
> On Thu, Dec 10, 2009 at 7:03 AM, John W. Linville
> <linville@tuxdriver.com> wrote:

> > Yes.  If you want me to do git pulls then you need to separate fixes
> > into a tree based on wireless-2.6.  Also, you should be conscientious
> > about adding "Cc: stable@kernel.org" to commit logs as appropriate.
> > The whole point of the pulls is to keep me from having to touch
> > the patches.
> 
> OK last question, is if we do take up the pull request method for
> ath9k at Atheros we still have people sending patches from the
> community so who would pick those up. Is it easier for you if we do so
> and then get them to you through our pull request? How about the
> stable fixes? Reason I ask if you pick some of these up it just means
> we need to rebase and I do prefer to keep a clean tree myself as well,
> although not required at all.

In the generic case, the driver/subsystem maintainer and I should
negotiate that in advance -- either way might be acceptable and either
way might call for special cases for individual patches.

So, feel free to propose how you would like to do it for ath9k in
another thread or a private email.  But in general I would think that
letting "outsider" (for lack of a better term) patches flow through
a driver/subsystem maintainer tree would be acceptable.  After all,
that implies a higher level of domain-specific review.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
