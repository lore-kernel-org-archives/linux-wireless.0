Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dell.nexicom.net ([216.168.96.13]:42524 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330Ab1EGBYQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 21:24:16 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-66-79-239-161.nexicom.net [66.79.239.161])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p471OEhH016385
	for <linux-wireless@vger.kernel.org>; Fri, 6 May 2011 21:24:15 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 4A1C11E015F
	for <linux-wireless@vger.kernel.org>; Fri,  6 May 2011 21:24:13 -0400 (EDT)
Message-ID: <4DC49F5D.4090401@lockie.ca> (sfid-20110507_032419_539427_8FAB7E50)
Date: Fri, 06 May 2011 21:24:45 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: debug logs
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are two dmesg outputs on each kernel after I do  modprobe ath9k
debug=0xffffffff and iwlist wlan0 scan | grep SSID

kernel-2.6.36.4 is good and returns  ~15 APs and associates to my AP
htp://lockie.ca/test/dmesg_good.txt.bz2

but kernel-2.6.38.5 is bad and returns ~0-3 APs and does not associate
to my AP
http://lockie.ca/test/dmesg_bad.txt.bz

Maybe someone can see something.
