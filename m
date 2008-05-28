Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4875 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650AbYE1W2d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 18:28:33 -0400
Date: Wed, 28 May 2008 17:48:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Alejandro Riveira =?iso-8859-1?Q?Fern=E1ndez?=
	<ariveira@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.26-rc4
Message-ID: <20080528214812.GB3133@tuxdriver.com> (sfid-20080529_002841_752529_D27006A2)
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org> <20080527124315.131b1343@Varda> <alpine.LFD.1.10.0805281307150.2958@woody.linux-foundation.org> <1212005877.21624.47.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1212005877.21624.47.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 28, 2008 at 10:17:57PM +0200, Johannes Berg wrote:

> > I suspect the oops is also why the bootup breaks, so it's likely al=
l the=20
> > same issue. Please save the dmesg into a file, reboot into a workin=
g=20
> > setup, and send that. Along with hw information (it's likely relate=
d to=20
> > your network device driver, since I've not seen an uproar of these =
kinds=20
> > of problems from everybody else..).
>=20
> Actually, please apply the patch "=EF=BB=BFrt2x00: Use atomic interfa=
ce
> iteration in irq context" before trying anything more, that'll fix it=
=2E
> I'm not sure where Linville is hiding ;)
>=20
> (http://article.gmane.org/gmane.linux.kernel.wireless.general/15268)

Zzzzzzz....huh, what?? :-)

I just sent a pull request to Dave M. with that patch in it.
Last weekend was a long one in the USA, so I apologize for the delay...

John
--=20
John W. Linville
linville@tuxdriver.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
