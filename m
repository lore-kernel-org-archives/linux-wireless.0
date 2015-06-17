Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49654 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbbFQUe3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 16:34:29 -0400
Message-ID: <1434573264.2594.0.camel@sipsolutions.net> (sfid-20150617_223432_198832_0CC03AA9)
Subject: Re: creating ap interface
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Dan Williams <dcbw@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 17 Jun 2015 22:34:24 +0200
In-Reply-To: <CACna6rwq6VB+mg2tLetmMQTA0xexbDwi=JdoBgHRxDB4EgeUeA@mail.gmail.com> (sfid-20150617_223255_654414_66333DC6)
References: <5581BEBA.1080500@broadcom.com>
	 <1434568011.1884.42.camel@sipsolutions.net>
	 <CACna6rwq6VB+mg2tLetmMQTA0xexbDwi=JdoBgHRxDB4EgeUeA@mail.gmail.com>
	 (sfid-20150617_223255_654414_66333DC6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-06-17 at 22:32 +0200, Rafał Miłecki wrote:

> >> When I create an AP interface using iw, it is followed by a change
> >> interface back to managed mode. I added a WARN_ON to see where it came

> I'm pretty sure it was for debugging purposes.

Oops, clearly. Sorry about that.

johannes


