Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:48936 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644AbYALOol (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2008 09:44:41 -0500
Message-ID: <4788D24E.30805@hauke-m.de> (sfid-20080112_144445_800463_7B034A92)
Date: Sat, 12 Jan 2008 15:44:30 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
CC: Michael Wu <flamingice@sourmilk.net>, linux-kernel@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8187 rate control doesn't work
References: <477F9890.5050107@hauke-m.de>	 <43e72e890801051354v280c0ceeo78790bb5f1f45314@mail.gmail.com>	 <47824D25.5090005@hauke-m.de> <43e72e890801070942y5abcc8acs31ac446d67414483@mail.gmail.com> <4787F03E.6080605@hauke-m.de>
In-Reply-To: <4787F03E.6080605@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have tested kernel 2.6.24-rc7-git4 with the build in rtl8187 module
and I have the same problem.

I can't ping the AP if the rate is set to auto or to something higher
than 11M. I have to set it to something less than 11M to be able to ping
the AP.

iwconfig shows a successful connection in both cases.

I am using Ubuntu 7.10 with vanilla kernel 2.6.24-rc7-git4 on AMD64
system with wpa_supplicant v0.5.8

--
Hauke
