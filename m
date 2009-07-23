Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from promwad.com ([83.149.69.23]:33500 "EHLO promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663AbZGWJWW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 05:22:22 -0400
Received: from mail.promwad.com ([195.222.85.229] helo=intranet.promwad.com)
	by promwad.com with esmtps (TLSv1:AES256-SHA:256)
	(Exim 4.63)
	(envelope-from <ivan.kuten@promwad.com>)
	id 1MTuVJ-0002Vs-Cv
	for linux-wireless@vger.kernel.org; Thu, 23 Jul 2009 12:22:21 +0300
Received: from [192.168.10.140]
	by intranet.promwad.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <ivan.kuten@promwad.com>)
	id 1MTuVF-0003yk-N2
	for linux-wireless@vger.kernel.org; Thu, 23 Jul 2009 12:22:17 +0300
Message-ID: <4A682BBD.90101@promwad.com>
Date: Thu, 23 Jul 2009 12:22:05 +0300
From: Ivan Kuten <ivan.kuten@promwad.com>
Reply-To: ivan.kuten@promwad.com
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: WPA2, compat-wireless-2.6.31-rc3, kernel 2.6.28 - rtl8187 - association
 works but no ping
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm testing rtl8187 on Blackfin platform (linux-2.6.28)
compat-wireless-2.6.31-rc3
driver rtl8187
wpa_supplicant-0.6.5

Sympthoms:
Association works but no ping in WPA2(AES)
Association works and ping is working with WPA(TKIP)

This is probably not a wpa_supplicant and it's config problem
because it's working (WPA2-AES and WPA-TKIP) on 2.6.28 with corresponding configs.

Any suggestions how to track down the problem?

Best regards,
Ivan





