Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:59420 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127Ab0DHIED (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 04:04:03 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 08 Apr 2010 01:04:03 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19389.36279.77368.650461@gargle.gargle.HOWL>
Date: Thu, 8 Apr 2010 13:33:03 +0530
To: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Vivek Natarajan <Vivek.Natarajan@Atheros.com>
Subject: [ath9k_htc] Current patches against 2.6.34-rc3-git4
In-Reply-To: <i2i2d0a357f1004060442sc332438bz4873484aa794aa2a@mail.gmail.com>
References: <i2i2d0a357f1004060442sc332438bz4873484aa794aa2a@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sedat Dilek wrote:
> Hi,
> 
> I (hope I) collected all ath9k_htc patches pending in [1].
> Unfortunately, my (quilt) series break against Linux 2.6.34-rc3-git4.
> Any hints?

An easier way to get the latest wireless drivers would be to use
compat-wireless.

See: http://linuxwireless.org/en/users/Download/

Sujith
