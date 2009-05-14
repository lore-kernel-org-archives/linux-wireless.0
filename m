Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:60166 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760286AbZENArZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 20:47:25 -0400
Received: by fxm2 with SMTP id 2so999186fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 13 May 2009 17:47:25 -0700 (PDT)
Subject: Re: [ath5k-devel] WoW for ath5k
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <69e28c910905131731t5f708339y3fc87b9035591115@mail.gmail.com>
References: <43e72e890905131718k739eef2eu35f76d4bf5b03dae@mail.gmail.com>
	 <69e28c910905131731t5f708339y3fc87b9035591115@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 14 May 2009 03:47:21 +0300
Message-Id: <1242262041.3241.30.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-05-14 at 02:31 +0200, G=C3=A1bor Stefanik wrote:
> On Thu, May 14, 2009 at 2:18 AM, Luis R. Rodriguez <mcgrof@gmail.com>=
 wrote:
> > BTW legacy-hal has this stuff :) Just grep for ATH_WOW
> >
> >  Luis
>=20
> Wow! :-)
>=20

Isn't Wow support platform dependent (BIOS...)
I think that only S3, and only if bios doesn't turn (put in D3cold) the
wireless device, it could work.

Btw, as I understand, WoW implies that somebody sends a packet with som=
e
predefined pattern, and that wakes the system, right?

Regards,
	Maxim Levitsky

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
