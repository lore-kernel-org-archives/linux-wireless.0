Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154]:57046 "EHLO
	pne-smtpout4-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753343AbYAWRo4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 12:44:56 -0500
Received: from [10.0.0.10] (80.220.119.243) by pne-smtpout4-sn2.hy.skanova.net (7.3.129)
        id 478BE6630008167D for linux-wireless@vger.kernel.org; Wed, 23 Jan 2008 18:44:46 +0100
Subject: Re: [PATCH 00/14] RFC: Driver for Wireless RNDIS USB devices.
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080123145243.GA3129@tuxdriver.com>
References: <20080120001342.25718.83669.stgit@fate.lan>
	 <1201094475.7733.1.camel@localhost>  <20080123145243.GA3129@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 23 Jan 2008 19:44:46 +0200
Message-Id: <1201110286.8696.10.camel@localhost> (sfid-20080123_174500_468573_5C5F3170)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-01-23 at 09:52 -0500, John W. Linville wrote:
> I would like to have this driver soon, and FWIW I just put it in the
> Fedora Rawhide kernel last night.
> 
> However, I find that it does not seem to associate with WEP networks
> on my USR5421.  I haven't had a chance to try it on open or WPA
> networks, nor have I had a chance to debug it.  It does scan and see
> the networks.
> 
> Have you tested the driver as posted?  What device(s) are you using?
> Have you used it on encrypted networks?

I guess I should start testing more if I'm going to be maintainer,
you're right WEP doesn't work. Unencrypted and WPA/WPA2 networks do work
for me but not WEP. Ad-Hoc and hidden WPA networks do not work either. I
have Buffalo WLI-U2-KG125S which should have same hardware/firmware as
USR5421.

 - Jussi

