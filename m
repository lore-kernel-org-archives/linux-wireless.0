Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.infocity.de ([80.64.180.66]:55350 "EHLO mail2.ccgmbh.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670AbYE1WGw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 18:06:52 -0400
Received: from [192.168.111.106] (i577B65C0.versanet.de [87.123.101.192])
	by mail2.ccgmbh.net (Postfix) with ESMTP id 4AE66B3AA4
	for <linux-wireless@vger.kernel.org>; Wed, 28 May 2008 23:52:40 +0200 (CEST)
From: Waldemar Krzok <waldemar@krzok.de>
To: linux-wireless@vger.kernel.org
Subject: bug(?) compat_wireless
Date: Wed, 28 May 2008 23:51:44 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200805282351.44721.waldemar@krzok.de> (sfid-20080529_000656_200808_7357789B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks,

I tried to install the newest compat_wireless driver for ZyDAS wifi adapter 
(buit-in USB wifi module) but without success. After downloading and 
unpacking the distribution 'make' terminated with error in file 
rtl8180_dev.c:249: "implicit declaration of function skb_get_queue_mapping". 
There is no declaration of this function neither in this file nor in the 
includes. Any hints?

My config: Medion Laptop, Linux Suse 10.3 distribution,  kernel 
2.6.22.5-31-default

many thanks for your fb work && greetings from Berlin

Waldemar
