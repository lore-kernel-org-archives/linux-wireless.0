Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.177]:9187 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222AbYHDRdW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 13:33:22 -0400
Received: by ik-out-1112.google.com with SMTP id c28so2668647ika.5
        for <linux-wireless@vger.kernel.org>; Mon, 04 Aug 2008 10:33:12 -0700 (PDT)
To: "Stefanik =?iso-8859-1?q?G=E1bor?=" <netrolller.3d@gmail.com>
Subject: Re: [PATCH 3/5] rt2x00: Implement HW encryption (rt73usb)
Date: Mon, 4 Aug 2008 19:57:01 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200808041636.41189.IvDoorn@gmail.com> <200808041638.24289.IvDoorn@gmail.com> <69e28c910808041022t66471abar35957b6570140819@mail.gmail.com>
In-Reply-To: <69e28c910808041022t66471abar35957b6570140819@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200808041957.01502.IvDoorn@gmail.com> (sfid-20080804_193327_491512_63224EB5)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 04 August 2008, Stefanik G=E1bor wrote:
> On Mon, Aug 4, 2008 at 4:38 PM, Ivo van Doorn <ivdoorn@gmail.com> wro=
te:
> > rt73usb supports hardware encryption.
> > rt73usb supports up to 4 shared keys and up to 64 pairwise keys.

<...>

> We need modparams for disabling HW crypto support if it misbehaves.

Hmm, I'm not that big fan of module parameters, but perhaps there shoul=
d
indeed be some toggle possibility. Well, I'll add that in a few days.

Ivo
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
