Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:62818 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbYFKTub (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 15:50:31 -0400
Received: by yw-out-2324.google.com with SMTP id 9so2015908ywe.1
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 12:50:20 -0700 (PDT)
Message-ID: <69e28c910806111250k4bfe0190h9cfd5937d47b1bbc@mail.gmail.com> (sfid-20080611_215035_179214_DA0478B0)
Date: Wed, 11 Jun 2008 21:50:19 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: Open source driver with binary HAL for BCM4313 from Broadcom
Cc: "Tim Gardner" <tim.gardner@canonical.com>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
In-Reply-To: <200806112047.00854.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48500F14.8070300@canonical.com> <200806112047.00854.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 11, 2008 at 8:47 PM, Michael Buesch <mb@bu3sch.de> wrote:
>
> On Wednesday 11 June 2008 19:44:52 Tim Gardner wrote:
> > John,
> >
> > Here is the URL to Broadcom's web site advertising their open source
> > driver with support for the BCM4313.
> >
> > http://www.broadcom.com/support/802.11/linux_sta.php
> >
> > rtg
>
> <quote>
> Make sure that you download the appropriate tar because the hybrid binary
> file must be of the appropriate architecture type. The hybrid binary file
> is agnostic to the specific version of the Linux kernel because it is
> designed to perform all interactions with the operating system through
> operating-system-specific files...
> </quote>
>
> --
> Greetings Michael.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Also, the download links are broken. And AFAIK we do support BCM4312,
although not PCI ID 0x4315 (that would be BCM4310).
(CCing the bcm43xx mailing list.)

--
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
