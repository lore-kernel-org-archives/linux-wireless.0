Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:53883 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680AbXJJNfm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 09:35:42 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Ifbif-0002m8-Mt
	for linux-wireless@vger.kernel.org; Wed, 10 Oct 2007 13:35:25 +0000
Received: from dslc-082-082-164-062.pools.arcor-ip.net ([82.82.164.62])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2007 13:35:25 +0000
Received: from feldmann_markus by dslc-082-082-164-062.pools.arcor-ip.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2007 13:35:25 +0000
To: linux-wireless@vger.kernel.org
From: Markus Feldmann <feldmann_markus@gmx.de>
Subject: Re: Patch for Kernel and Ath5k
Date: Wed, 10 Oct 2007 15:35:01 +0200
Message-ID: <feike5$fod$1@sea.gmane.org> (sfid-20071010_143602_640518_E13ABA43)
References: <feieb9$nvg$1@sea.gmane.org> <200710102132.21790.bruno@thinktube.com> <feih2c$21f$1@sea.gmane.org> <200710101502.20202.hs4233@mail.mn-solutions.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
In-Reply-To: <200710101502.20202.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Holger Schurig schrieb:
>> Do you mean it will fetch the whole Kernel Sources, with the
>> linux-wireless Sources?
> 
> Yes, it will.
I did what you said, but in the "make menuconfig" do not appear the Option,
<M>   Atheros 5xxx wireless cards support

Maybe there is some Option Missing?

Here is what i did,

1.) cd /usr/src
2.) git-clone 
git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
3.)cd wireless-2.6
4.)git checkout -b everything origin/everything
5.)make menuconfig
6.)
Networking  --->
   Wireless  --->
     <M> Improved wireless configuration API
     <M> Generic IEEE 802.11 Networking Stack (mac80211)

Any Idea?

