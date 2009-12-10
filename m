Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33342 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbZLJPPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2009 10:15:11 -0500
Date: Thu, 10 Dec 2009 10:03:18 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org,
	davem@davemloft.net
Subject: Re: Revised wireless tree management practices
Message-ID: <20091210150318.GB2955@tuxdriver.com>
References: <20091209211054.GB32058@tuxdriver.com> <87ljhb0x0h.fsf@purkki.valot.fi> <20091210134733.GC11112@tuxdriver.com> <87ein30vt4.fsf@purkki.valot.fi> <43e72e890912100631if1c17b2l597168813db4a19c@mail.gmail.com> <20091210143754.GA2955@tuxdriver.com> <43e72e890912100653p3890705u4f88dd19026a5877@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <43e72e890912100653p3890705u4f88dd19026a5877@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 10, 2009 at 06:53:43AM -0800, Luis R. Rodriguez wrote:
> On Thu, Dec 10, 2009 at 6:37 AM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > On Thu, Dec 10, 2009 at 06:31:02AM -0800, Luis R. Rodriguez wrote:
> >> On Thu, Dec 10, 2009 at 6:04 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
> >> > "John W. Linville" <linville@tuxdriver.com> writes:
> >> >
> >> >> I still see value in a tree that has a reasonably stable base and
> >> >> contains both wireless fixes and wireless features.
> >> >
> >> > I agree, it makes things a lot easier.
> >> >
> >> >> So, I think wireless-testing remains as the focal point for wireless
> >> >> LAN testing and development. I'll just be getting patches there in a
> >> >> slightly different process.
> >> >
> >> > Sounds very good. So I'll continue using wireless-testing. Thanks.
> >>
> >> But we use wireless-next as base though if we want to send you pull
> >> requests, ay?
> >
> > Yes, that is correct -- people that want to send patches (or simply
> > test) should use wireless-testing.  People that want to send pull
> > requests need to have trees based on wireless-2.6 (for fixes)
> 
> Typically we have relied on you to push fixes into wireless-2.6, does
> this change a bit now in that we should try to keep better track of
> stable fixes and send them to you instead if we're doing the pull
> request method?

Yes.  If you want me to do git pulls then you need to separate fixes
into a tree based on wireless-2.6.  Also, you should be conscientious
about adding "Cc: stable@kernel.org" to commit logs as appropriate.
The whole point of the pulls is to keep me from having to touch
the patches.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
