Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:51442 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbYLVHez (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 02:34:55 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/15] rt2x00: Implement Powersaving
Date: Mon, 22 Dec 2008 08:34:43 +0100
Cc: "David Shwatrz" <dshwatrz@gmail.com>,
	"Ivo van Doorn" <ivdoorn@gmail.com>,
	"John Linville" <linville@tuxdriver.com>,
	rt2400-devel@lists.sourceforge.net
References: <200812201052.00655.IvDoorn@gmail.com> <200812201052.43061.IvDoorn@gmail.com> <31436f4a0812210953r3b715989vd76b907fe6e4fe8d@mail.gmail.com>
In-Reply-To: <31436f4a0812210953r3b715989vd76b907fe6e4fe8d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812220834.43412.hs4233@mail.mn-solutions.de> (sfid-20081222_083459_016687_7C51CB28)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hi,
> Great new ! It seems to me that this is the first **usb**
> wireless device with power save support (and please correct me
> if I am wrong).

The libertas device as used in the OLPC ?
It's a non-mac80211 device, but uses powersave nethertheless.
