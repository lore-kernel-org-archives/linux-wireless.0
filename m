Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:30787 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630AbYCYPkz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 11:40:55 -0400
Received: by py-out-1112.google.com with SMTP id u52so5004924pyb.10
        for <linux-wireless@vger.kernel.org>; Tue, 25 Mar 2008 08:40:54 -0700 (PDT)
Message-ID: <43e72e890803250840v4b09c9faia0373f639b688a4d@mail.gmail.com> (sfid-20080325_154057_327699_8991A583)
Date: Tue, 25 Mar 2008 11:40:53 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: gentoo ebuild for compat wireless (resend)
Cc: "Florian Manschwetus" <florianmanschwetus@gmx.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1206458946.16475.285.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <47E7A8DB.5020106@gmx.de>
	 <43e72e890803241304g13ea443co4e4afb1681da989c@mail.gmail.com>
	 <47E839BE.5030806@gmx.de>
	 <43e72e890803241630n1906147ej1190d7562f5d1354@mail.gmail.com>
	 <47E83DF5.9030401@gmx.de> <47E8DEAD.1040808@gmx.de>
	 <43e72e890803250725x2fae4748idcfcea70e114d23f@mail.gmail.com>
	 <47E919BF.4010308@gmx.de> <1206458946.16475.285.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 25, 2008 at 11:29 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>  > but this is a problem, when i distribute a ebuild it is useful to have a
>  > locked version, so that i get reproducible results.
>  > My problem, is that i have currently no resources to rehost this
>  > tar-ball. (no official gentoo-dev, no reliable webserver)
>  >
>  > But, i see currently no other solution than rehosting.
>
>  We can keep a few around, but definitely not forever, so you'll have to
>  find somewhere else to host your "known good" versions. While I could do
>  it resource-wise, I don't want the admin overhead of having various
>  distros tell us which ones are known-good for them.
>
>  You could simply get a gentoo dev to help you out.

I can probably get a historic archive of the tarballs hosted on orbit
or winlab site. Give me a few and I'll start something. Let me remind
you now that compat-wireless-2.6.tar.bz2 tarball has anti-hotlinking
enabled but the compat-wireless-2008-* tarballs won't. Anti-hotlinking
disables people from linking to the tarball externally, this will
force them to read the Download page if redirected from a separate
page, once they go there they can download the tarball. The dated
tarballs don't have this anti-hotlinking enabled now (Johannes just
set this up) so the ebuild/wget'ing should work directly for the dated
tarballs.

  Luis
