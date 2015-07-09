Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49376 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbbGIQvL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 12:51:11 -0400
Date: Thu, 9 Jul 2015 12:51:02 -0400
From: Theodore Ts'o <tytso@mit.edu>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Julian Calaby <julian.calaby@gmail.com>,
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
Message-ID: <20150709165102.GA9417@thunk.org> (sfid-20150709_185116_185741_CEF9B431)
References: <559BBDD6.7040808@users.sourceforge.net>
 <CAH6sp9O=NgJXOJzQaaA0o_yae+ae1oJa5Kcqmpo-WWBO_xUW+g@mail.gmail.com>
 <559BFB19.2080700@users.sourceforge.net>
 <CAGRGNgXTN8AxBNNfie4KvvErOXm3LUyL_QLLWQ6TN_wJgJkD-A@mail.gmail.com>
 <559CCC9D.8050606@users.sourceforge.net>
 <CAGRGNgWcHxwjx07A45No8vArXR12JGKcfif1Rvi30PQbJs4SGQ@mail.gmail.com>
 <559CED4C.1080402@users.sourceforge.net>
 <CAGRGNgU1SSUw-97aS0nhFObcMpLPdP3ej9WWNVwN77Fd=ws-bQ@mail.gmail.com>
 <20150708150335.GB20551@thunk.org>
 <559D416A.7050601@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <559D416A.7050601@users.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 08, 2015 at 05:27:38PM +0200, SF Markus Elfring wrote:
> > Note also that some maintainers have work flow that deliberately smash
> > the date (i.e., because they are using a system such as guilt),
> > so if you are depending on the submitted timestamp, it's going to
> > break on you.
> 
> Thanks for your hint.
> 
> I am just trying to offer the possibility for the reuse of a more
> precise commit timestamp together with an appropriate author mail
> address for my update suggestions.
> Do you reject any more such message field overrides?

Well, I won't hold it against you, since I also often need to fix
patches or git commit descriptions anyway.  But at the same time, my
workflow (which you have no right to dictate) **will** destroy your
timestamp.  Given that you haven't explained why you want to do this,
I'm not going have much sympathy if you complain.

Personally, given that you're going through some extremely baroque
e-mail/patchsubmission scheme, I don't understand why you can't also
arrange to override the Date field in the e-mail header.  But I don't
really care all that much, because I can ignore your timestamp no
matter where you put it.

Regards,

					- Ted
