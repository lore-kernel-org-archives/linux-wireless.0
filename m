Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:9065 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbXKKQQX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2007 11:16:23 -0500
Received: by py-out-1112.google.com with SMTP id u77so711594pyb
        for <linux-wireless@vger.kernel.org>; Sun, 11 Nov 2007 08:16:22 -0800 (PST)
Message-ID: <f6ca9fed0711110816r19bd4d50p78aad02464a32099@mail.gmail.com> (sfid-20071111_161628_099825_18139BD4)
Date: Sun, 11 Nov 2007 17:16:22 +0100
From: dragoran <drago01@gmail.com>
To: "=?ISO-8859-1?Q?Alexander_G=F6rtz?=" <AlexanderGoertz@gmx.de>
Subject: Re: [ipw3945-devel] iwl3945 cannot connect to 802.11b access point
Cc: ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	mabbas <mabbas@linux.intel.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Zhu Yi" <yi.zhu@intel.com>, "Pavel Roskin" <proski@gnu.org>
In-Reply-To: <47372943.1040204@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200711011306.29377.gkiagiad@csd.uoc.gr>
	 <472BB480.1020002@gmail.com> <473314EF.40505@gmx.de>
	 <f6ca9fed0711081243u1984e126i87657ed8d182915d@mail.gmail.com>
	 <47372943.1040204@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 11, 2007 5:09 PM, Alexander G=F6rtz <AlexanderGoertz@gmx.de> wro=
te:
> dragoran schrieb:
>
> >> Hi, this patch doesn't work for me it generates 100% CPU traffic s=
o that
> >> I was unable to boot and had to unload the iwl3945 module during s=
tartup
> >> to be able to work with my machine again. So I'm open for any new =
solutions.
> >>
> >
> > try this one:
> >
> > http://intellinuxwireless.org/repos/?p=3Diwlwifi.git;a=3Dcommitdiff=
_plain;h=3De03b2aaa1ecf22ab203cc8fc40c0eb1e31b5c842;hp=3D9578f421b2c64f=
837e2df02fd6eff97ce03f1b36
> >
> > seems that there was a small bug in the previous one.
> >
> >
> This Patch works fine for me now I can connect to 802.11b Networks. I
> hope this patch will be included in the next version of iwlwifi.
>
John is it possible to get this one into .24 too ?
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
