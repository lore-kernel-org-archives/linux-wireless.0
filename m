Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:38746 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706Ab2BHIzx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 03:55:53 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Michael Green <green@qca.qualcomm.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	Robert =?utf-8?Q?Gr=C3=B8nning?= <slimg@iggu.org>
Subject: Re: [wireless-regdb] wireless-regdb: Update regulatory rules for Norway (NO)
References: <87pqgkxn25.fsf@nemi.mork.no>
	<20111128181912.GB2681@tuxdriver.com>
	<20120207195415.GG5560@tuxdriver.com>
	<CAB=NE6VVcQgum4mQ5eooS2yXo-NNXHvujsUwpbEwNdQQSreaBA@mail.gmail.com>
Date: Wed, 08 Feb 2012 09:55:09 +0100
In-Reply-To: <CAB=NE6VVcQgum4mQ5eooS2yXo-NNXHvujsUwpbEwNdQQSreaBA@mail.gmail.com>
	(Luis R. Rodriguez's message of "Tue, 7 Feb 2012 12:37:59 -0800")
Message-ID: <87mx8t7lhu.fsf@nemi.mork.no> (sfid-20120208_095556_743244_EABB5892)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@frijolero.org> writes:
> On Tue, Feb 7, 2012 at 11:54 AM, John W. Linville
> <linville@tuxdriver.com> wrote:
>> Well, sorry for the delay...  I will take this silence as "no
>> objection". :-)
>
> Sorry, I did get a reply by Michael Green on 11/28/2011 but I never
> followed up with the list. Apologies as well with the delay, but here
> is our review.
>
> The European Union has some harmonized European radio conformance spec
> and QCA's interpretation and position is that that spec overrides
> deviations for end products for specific countries like the one being
> recommended for Norway. This also means that QCA does not deviate for
> EU countries on specs, even if countries have their own quirks, for
> any country in the EU.
>
> Supporting changes like these are a deviation from what QCA is used to
> using and testing and we unfortunately cannot verify any individual
> country specific changes like the one proposed for the EU. It is also
> our sentiment that we stand to gain more if we simply unify the EU
> requirements through the harmonized spec, it provides simplicity, its
> what we use and we can help in that regards. If wireless-regdb decides
> to take a different path we simply will not be able to verify and
> validate these changes. I'd be surprised if any other 802.11 vendor
> differs from this position.

I fully agree.

However, this should really be taken up with the regulatory bodies
deviating from the conformance spec.  It cannot simply be fixed by
ignoring it in the regulatory database. That just implies that the
regulatory database deviates from the regulations, and that's no good...

But if you want to put this change on hold and work towards harmonizing
the regulations instead, then I'm fine with that solution.


Bjørn
