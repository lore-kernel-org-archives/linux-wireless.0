Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:32922 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684Ab2KZGkN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 01:40:13 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1TcsMX-0007bj-MK
	for linux-wireless@vger.kernel.org; Mon, 26 Nov 2012 07:40:18 +0100
Received: from ice.139.client237.youtele.com ([ice.139.client237.youtele.com])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 07:40:13 +0100
Received: from charvi.mehta by ice.139.client237.youtele.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 07:40:13 +0100
To: linux-wireless@vger.kernel.org
From: Charvi <charvi.mehta@einfochips.com>
Subject: Re: Access Point Mode for Ralink RT5370? - Success
Date: Mon, 26 Nov 2012 06:39:51 +0000 (UTC)
Message-ID: <loom.20121126T073219-553@post.gmane.org> (sfid-20121126_074020_523240_D964F3B7)
References: <20120719133452.2fb375ae@emcraft.com> <CAOZOX0V=npQuQ03kur0mo7PtkdGVYiFO5B3OKhB7CMibLk50Ew@mail.gmail.com> <20120807190140.4796a045@emcraft.com> <CAOZOX0V1_zA3iTXhz7J4_t-BxNQ6k6V_-A_jky2B=fpbya-Lqg@mail.gmail.com> <20120816192839.1e595e4b@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergei Poselenov <sposelenov@...> writes:

> 
> Hello Ivo, all,
> 
> I just want to report that we successfully built and configured DWA-140
> (rev B3, RT5370 chip) USB-WiFi in access point mode. For this, we built
> vcompat-wireless modules and hostapd and lbnl (required by hostapd).
> 
> Our target is the LPC1788 (ARM Cortex-M3 SOC) running Linux 2.6.33,
> with USB support.
> 
> Our toolchain combo is CodeSourcery arm-2010q1, with uClibc modified to
> support clone() and linuxthreads.
> 
> Thank you for your comments.
> 
> Regards,
> Sergei Poselenov, Emcraft Systems
 
Hi Sergei,

   I am also using a USB stick with RT5370 and want to configure it in AP mode.
I am new to the compat wireless drivers and modules but when I build them I do
not get any module like "rt5370.ko". Which module from compat wireless package
do I need to install for RT5370. I am using the latest compat wireless package
from
http://wireless.kernel.org/download/compat-wireless-2.6/compat-wireless.tar.bz2.

Thanks,
Charvi.

