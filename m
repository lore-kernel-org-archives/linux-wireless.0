Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay2.web4ce.cz ([93.190.48.82]:46721 "EHLO relay2.web4ce.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952Ab2LOUoY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Dec 2012 15:44:24 -0500
Received: from [81.0.202.202] (msrv3.web4ce.cz [93.190.49.98])
	by relay2.web4ce.cz (Postfix) with ESMTP id 1E73A2213F2
	for <linux-wireless@vger.kernel.org>; Sat, 15 Dec 2012 21:44:22 +0100 (CET)
Message-ID: <50CCE126.6020503@berycz.net> (sfid-20121215_214427_880837_45E6D313)
Date: Sat, 15 Dec 2012 21:44:22 +0100
From: Martin Beran <info@berycz.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Piotr Haber <phaber@broadcom.com>
Subject: Re: bugreport Broadcom BCM4313
References: <50CCCF49.7040108@berycz.net>
In-Reply-To: <50CCCF49.7040108@berycz.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(sry for my mistake in the subject before, Broadcom BCM4313 it is)

to clarify
it is still asking for wpa key, but doesnt want to connect

from irc:
 > b6fc28a158076ca2764edc9a6d1e1402f56e1c0c is the bad commit
 > it added usleep_range() instead of udelay()

Thanks
Regards
Martin Beran
