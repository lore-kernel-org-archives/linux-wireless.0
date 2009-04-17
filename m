Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sous-sol.org ([216.99.217.87]:56892 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752339AbZDQVMJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2009 17:12:09 -0400
Date: Fri, 17 Apr 2009 13:26:00 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Chris Wright <chrisw@sous-sol.org>, stable@kernel.org,
	Arnaud Patard <apatard@mandriva.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [stable] [PATCH] rt2x00: Fix SLAB corruption during rmmod
Message-ID: <20090417202600.GA14852@sequoia.sous-sol.org> (sfid-20090417_231213_609742_5104F055)
References: <200904012118.12391.IvDoorn@gmail.com> <20090417001807.GA5020@hera.kernel.org> <49E7F3E6.2010809@gmail.com> <a32f33a40904162356r5dddeed8u60f63e5c0acfc506@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <a32f33a40904162356r5dddeed8u60f63e5c0acfc506@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Ivo Van Doorn (ivdoorn@gmail.com) wrote:
> >> Who is the Author of this patch? =A0The Signed-off-by order sugges=
ts is
> >> Gertjan.
> >
> > Indeed, I have been the author of the patch.
>=20
> Yeah, Gertjan is indeed the author, I forgot to add
> the Fom: line at the top of the patch to make that more clear.

Great, thanks, I'll add that in.
-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
