Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fallback.mer-nm.internl.net ([217.149.192.105]:42021 "EHLO
	fallback.mer-nm.internl.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752395Ab2GVTLA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jul 2012 15:11:00 -0400
Received: from smtp20.nijmegen.internl.net (smtp20.nijmegen.internl.net [217.149.192.18])
	by fallback.mer-nm.internl.net (Postfix) with ESMTP id B028940999
	for <linux-wireless@vger.kernel.org>; Sun, 22 Jul 2012 21:08:53 +0200 (CEST)
Received: from fileserver.lan (81-57.bbned.dsl.internl.net [92.254.57.81])
	by smtp20.nijmegen.internl.net (8.13.8/2.04) with ESMTP id q6MJ5muG026849
	for <linux-wireless@vger.kernel.org>; Sun, 22 Jul 2012 21:05:49 +0200 (CEST)
Received: from localhost ([127.0.0.1] helo=fileserver.lan)
	by fileserver.lan with esmtp (Exim 4.72)
	(envelope-from <Mijzelf@Live.com>)
	id 1St1TP-0007dW-Ev
	for linux-wireless@vger.kernel.org; Sun, 22 Jul 2012 21:05:47 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Sun, 22 Jul 2012 21:05:45 +0200
From: Mijzelf <Mijzelf@Live.com>
To: <linux-wireless@vger.kernel.org>
Subject: [Patch] on typo in
 compat-wireless-2012-05-08/include/linux/compat-2.6.28.h
Reply-To: <Mijzelf@Live.com>
Message-ID: <64da8470918769de8cac7e449876961b@fileserver.lan> (sfid-20120722_211105_794503_C0671D48)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

diff a/include/linux/compat-2.6.28.h b/include/linux/compat-2.6.28.h
30c30
< #if defined(CONFIG_64BIT) || defined(CONFIG_X86_PAE) || 
defned(CONFIG_PPC64) || defined(CONFIG_PHYS_64BIT)
---
> #if defined(CONFIG_64BIT) || defined(CONFIG_X86_PAE) || 
> defined(CONFIG_PPC64) || defined(CONFIG_PHYS_64BIT)

