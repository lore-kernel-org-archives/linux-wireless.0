Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp20.nijmegen.internl.net ([217.149.192.18]:62348 "EHLO
	smtp20.nijmegen.internl.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752401Ab2GVTLi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jul 2012 15:11:38 -0400
Received: from fileserver.lan (81-57.bbned.dsl.internl.net [92.254.57.81])
	by smtp20.nijmegen.internl.net (8.13.8/2.04) with ESMTP id q6MJBauX029648
	for <linux-wireless@vger.kernel.org>; Sun, 22 Jul 2012 21:11:36 +0200 (CEST)
Received: from localhost ([127.0.0.1] helo=fileserver.lan)
	by fileserver.lan with esmtp (Exim 4.72)
	(envelope-from <Mijzelf@Live.com>)
	id 1St1Z1-0007pI-Ef
	for linux-wireless@vger.kernel.org; Sun, 22 Jul 2012 21:11:35 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Sun, 22 Jul 2012 21:11:34 +0200
From: Mijzelf <Mijzelf@Live.com>
To: <linux-wireless@vger.kernel.org>
Subject: Uknown symbols in =?UTF-8?Q?rfkill=5Fbackport=2Eko=20on=20=32=2E?=
 =?UTF-8?Q?=36=2E=32=35=2E=31=37=20on=20mips?=
Reply-To: <Mijzelf@Live.com>
Message-ID: <0621389a37a568a7ebd526b0adc87a48@fileserver.lan> (sfid-20120722_211148_318380_A52A0F4C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying to get ath9k from compat-wireless-2012-05-08 running on a 
2.6.25.17 kernel on mips. The module refuses to load, due to unkown 
symbols.
# modprobe ath9k
modprobe: can't load module rfkill_backport 
(updates/net/rfkill/rfkill_backport.ko): unknown symbol in module, or 
unknown parameter
# dmesg
rfkill_backport: Unknown symbol input_register_handle
rfkill_backport: Unknown symbol input_open_device
rfkill_backport: Unknown symbol input_close_device
rfkill_backport: Unknown symbol input_unregister_handler
rfkill_backport: Unknown symbol input_register_handler
rfkill_backport: Unknown symbol input_unregister_handle

Any suggestions?
