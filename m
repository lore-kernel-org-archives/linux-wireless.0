Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:48856 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbYAHP4d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2008 10:56:33 -0500
Received: by ug-out-1314.google.com with SMTP id z38so3309108ugc.16
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jan 2008 07:56:32 -0800 (PST)
Date: Tue, 8 Jan 2008 16:55:30 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?=
	<ariveira@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
Message-ID: <20080108165530.19b2d03a@Varda> (sfid-20080108_155637_207764_1E53F629)
In-Reply-To: <200801081630.31110.mb@bu3sch.de>
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
	<200801071830.51895.mb@bu3sch.de>
	<20080107212344.1372cc47@Varda>
	<200801081630.31110.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

El Tue, 8 Jan 2008 16:30:30 +0100
Michael Buesch <mb@bu3sch.de> escribi=C3=B3:

> On Monday 07 January 2008 21:23:44 Alejandro Riveira Fern=C3=A1ndez w=
rote:
>
> > =20
> >  How can I check? The source code I build does indeed have the line
> >  you quoted on net/mac80211/rx.c:1486 Is that what you are asking f=
or?
> > =20
> >  WARN_ON_ONCE(((unsigned long)(skb->data + hdrlen)) & 3);
>=20
> Yes fine.
> Patches are on their way. Ignore the warning for now. It is harmless.
>=20

  Thank you very much for your time. Keep on the good work :)


-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
