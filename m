Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53358 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331AbZGGRPw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2009 13:15:52 -0400
Date: Tue, 7 Jul 2009 13:05:46 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] p54: fix beacon template dtim IE corruption
Message-ID: <20090707170546.GD2768@tuxdriver.com>
References: <200907041824.07655.chunkeey@web.de> <20090707160431.GB2768@tuxdriver.com> <200907072033.10183.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <200907072033.10183.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 07, 2009 at 08:33:10PM +0200, Christian Lamparter wrote:
> On Tuesday 07 July 2009 18:04:32 John W. Linville wrote:
> > On Sat, Jul 04, 2009 at 06:24:07PM +0200, Christian Lamparter wrote:
> > > This patch fixes a regression that sneaked in with 
> > > "[PATCH] p54: re-enable power save feature".
> > > When p54_beacon_format_ie_tim was divided up
> > > and rewritten to use skb_* macros.
> > 
> > I don't seem to have any record of that patch,
> hmm, it's right here...
> http://www.spinics.net/lists/linux-wireless/msg35201.html
> 
> maybe it was lost during the holiday, should I prepare a resend?

Probably...perhaps I deleted it after reading this?

	http://www.spinics.net/lists/linux-wireless/msg35222.html

:-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
