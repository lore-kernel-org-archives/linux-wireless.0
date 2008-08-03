Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:31575 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008AbYHCVLO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 17:11:14 -0400
Received: by nf-out-0910.google.com with SMTP id d3so631393nfc.21
        for <linux-wireless@vger.kernel.org>; Sun, 03 Aug 2008 14:11:12 -0700 (PDT)
To: "Stefanik =?iso-8859-1?q?G=E1bor?=" <netrolller.3d@gmail.com>
Subject: Re: [PATCH] rt2x00: Disable link tuning in rt2500usb
Date: Sun, 3 Aug 2008 23:34:50 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200808031657.27710.IvDoorn@gmail.com> <69e28c910808031113u2f5ff20dq672e8a801224e35c@mail.gmail.com>
In-Reply-To: <69e28c910808031113u2f5ff20dq672e8a801224e35c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200808032334.50251.IvDoorn@gmail.com> (sfid-20080803_231118_544665_A0B5B5F6)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 03 August 2008, Stefanik G=E1bor wrote:
> On Sun, Aug 3, 2008 at 4:57 PM, Ivo van Doorn <ivdoorn@gmail.com> wro=
te:
> > + * in TX capabilities only untill association kicks in. Immediatel=
y
>=20
> typo - until
>=20
> > + * after the successfull association all TX frames will be kept in=
 the
>=20
> typo - successful

Thanks, v2 coming up. :)

Ivo
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
