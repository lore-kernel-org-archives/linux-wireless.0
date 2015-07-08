Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47167 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205AbbGHPDo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2015 11:03:44 -0400
Date: Wed, 8 Jul 2015 11:03:35 -0400
From: Theodore Ts'o <tytso@mit.edu>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>,
	Frans Klaver <fransklaver@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Chris Park <chris.park@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	Julia Lawall <julia.lawall@lip6.fr>,
	kernel-janitors@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: Clarification for the use of additional fields in the message
 body
Message-ID: <20150708150335.GB20551@thunk.org> (sfid-20150708_170406_257552_5A4AE1B2)
References: <559B85CD.6040200@users.sourceforge.net>
 <CAH6sp9Npqma18pj=ZsxYpCNDCm-AjjXvw61MGKBEKSYvg_LUBg@mail.gmail.com>
 <559BBDD6.7040808@users.sourceforge.net>
 <CAH6sp9O=NgJXOJzQaaA0o_yae+ae1oJa5Kcqmpo-WWBO_xUW+g@mail.gmail.com>
 <559BFB19.2080700@users.sourceforge.net>
 <CAGRGNgXTN8AxBNNfie4KvvErOXm3LUyL_QLLWQ6TN_wJgJkD-A@mail.gmail.com>
 <559CCC9D.8050606@users.sourceforge.net>
 <CAGRGNgWcHxwjx07A45No8vArXR12JGKcfif1Rvi30PQbJs4SGQ@mail.gmail.com>
 <559CED4C.1080402@users.sourceforge.net>
 <CAGRGNgU1SSUw-97aS0nhFObcMpLPdP3ej9WWNVwN77Fd=ws-bQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGRGNgU1SSUw-97aS0nhFObcMpLPdP3ej9WWNVwN77Fd=ws-bQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 08, 2015 at 09:05:53PM +1000, Julian Calaby wrote:
> If multiple people are submitting identical changes, then the one that
> is applied is the one the maintainer sees first, which will most
> likely be determined by which one hit their inbox / list first. Nobody
> is going to look at timestamps in emails to determine which one will
> be applied.

And some maintainers may choose *not* to act on a patch first, even if
they see it first.  They might be focused on bug fix patches, and not
act on cleanup or feature patches until -rc3 or rc4.  Or maybe they
will use separate branches for "urgent_for_linus" patches, so two
different patchs may end up in completely different git flows.

> If you're worried about which one of several versions of a patch will
> be applied, change the subject to [PATCH v2] ..... instead of [PATCH]
> .... for the second version.

*Please* do this.  In fact, this is the one thing I wish git
send-email would do automatically, along with having a place to edit
and track the 0/N summary patch.

> >> To be honest, I've only ever used that timestamp for reporting
> >> purposes at work, and I'd be surprised if anyone was doing anything
> >> other than that with them.
> >
> > Thanks for your detailed feedback.

Note also that some maintainers have work flow that deliberately smash
the date (i.e., because they are using a system such as guilt), so if
you are depending on the submitted timestamp, it's going to break on
you.

							- Ted
