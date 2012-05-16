Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38786 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131Ab2EPUqf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 16:46:35 -0400
Message-ID: <1337201182.18519.15.camel@jlt3.sipsolutions.net> (sfid-20120516_224641_413968_03092B49)
Subject: Re: [Lf_driver_backport] [PATCH] compat: backport ether_addr_equal
From: Johannes Berg <johannes@sipsolutions.net>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>,
	Ozan =?UTF-8?Q?=C3=87a=C4=9Flayan?= <ozancag@gmail.com>,
	mcgrof@kernel.org, linux-wireless@vger.kernel.org,
	lf_driver_backport@lists.linux-foundation.org,
	linux-bluetooth@vger.kernel.org
Date: Wed, 16 May 2012 22:46:22 +0200
In-Reply-To: <4FB40FF0.4050809@hauke-m.de> (sfid-20120516_223716_008251_1D472FFC)
References: <1337162148-16499-1-git-send-email-ozancag@gmail.com>
	 <CAB=NE6W2dz=Ld=w5+7jexKk9xfADhk644mc4C=TtbvBZ9_cKGg@mail.gmail.com>
	 <4FB40FF0.4050809@hauke-m.de> (sfid-20120516_223716_008251_1D472FFC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-16 at 22:37 +0200, Hauke Mehrtens wrote:

> > Content-Type: text/plain; charset="utf-8"
> > Content-Transfer-Encoding: base64
> > 
> > And then all I see is this when I save the e-mail to a txt file, given
> > that the encoding is base64. This is odd given that I see you sent
> > this with X-Mailer: git-send-email 1.7.10.1 -- so not sure how this
> > ended up going out like this.
> 
> That's strange, when I save this mail I got over the mailing list with
> Thunderbird it is not based64 encoded and when looking into the source
> code with my mail program it is normal text mail.
> 
> From:	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
> Subject: [PATCH] compat: backport ether_addr_equal
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit

Well, which list? :-)

I suspect you looked at linux-wireless, and Luis looked at
lf_driver_backport (given his reply tag), so maybe the
lf_driver_backport list re-encoded the email.

johannes

