Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:21101 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573AbYGGVLp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 17:11:45 -0400
Received: by nf-out-0910.google.com with SMTP id d3so696390nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jul 2008 14:11:43 -0700 (PDT)
To: "Stefanik =?iso-8859-1?q?G=E1bor?=" <netrolller.3d@gmail.com>
Subject: Re: [Rt2400-devel] rt2500pci: Failed to initialize hw. But works with ancient rt2500-1.1.0
Date: Mon, 7 Jul 2008 23:19:44 +0200
Cc: rt2400-devel@lists.sourceforge.net,
	"Stefan Bauer" <stefan.bauer@cs.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200807072253.46295.stefan.bauer@cs.tu-chemnitz.de> <200807072308.57529.IvDoorn@gmail.com> <69e28c910807071410h17cd6815jd6577673f73dc092@mail.gmail.com>
In-Reply-To: <69e28c910807071410h17cd6815jd6577673f73dc092@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200807072319.44733.IvDoorn@gmail.com> (sfid-20080707_231149_160884_E445EFF3)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 07 July 2008, Stefanik G=E1bor wrote:
> On Mon, Jul 7, 2008 at 11:08 PM, Ivo van Doorn <ivdoorn@gmail.com> wr=
ote:
> > Check if the arc4 and ecb modules are loaded before loading mac8021=
1 & rt2500pci.
> >
> > Ivo
>=20
> Shouldn't we make mac80211 depend on arc4 and ecb?

They do depend on those modules, but for some reason they
are not always automatically loaded when the mac80211 module is loaded.

Ivo
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
