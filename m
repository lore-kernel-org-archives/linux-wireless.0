Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:33015 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120AbaFLHQD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2014 03:16:03 -0400
Received: by mail-ie0-f170.google.com with SMTP id tr6so786603ieb.15
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jun 2014 00:16:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53987997.2040101@lwfinger.net>
References: <53987997.2040101@lwfinger.net>
Date: Thu, 12 Jun 2014 09:16:02 +0200
Message-ID: <CAGXE3d81xMB3Y4WdTBPHKCC91QaieAQd5xzAqWSgGeonbD7_vw@mail.gmail.com> (sfid-20140612_091608_227412_94C30487)
Subject: Re: Driver for Mediatek MT7630E
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stanislaw Gruszka <stf_xl@wp.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

On Wed, Jun 11, 2014 at 5:45 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> In a recent E-mail interchange
> (http://marc.info/?l=linux-wireless&m=140238255916367&w=2), I was made aware
> that this device is not currently being handled by any driver in the kernel,
> but that there was a GitHub repo at https://github.com/anthonywong/mt7630.
> That code modifies rt2800pci to operate the MT7630E, but it is quite
> outdated.
>
> As a followup, I found such a device at a reasonable price on E-bay, and
> ordered it. It should arrive next week. I also was able to find the firmware
> in an RPM for SUSE SLE11, and a license allowing redistribution. Before I
> start modifying rt2800pci for this new device, I want to be assured that
> this modification is not currently being done by anyone in the rt2x00
> project. There is too much to be done to duplicate effort.

I'm not doing anything in this regard at the moment. So I'm really glad if you
are working on that!

CC'ed Stanislaw even though I don't think he's doing anything regarding the
device you've mentioned.

> For interested readers, I have modified the GitHub code to compile using the
> current wireless-testing kernel source. If there is sufficient interest, I
> could set up a new GH repo for it as an interim measure with conditional
> code allowing it to build on recent kernels (3.5+).

Awesome news.

Thanks,
Helmut
