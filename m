Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from batman.blixtvik.net ([87.96.254.3]:46583 "EHLO
	batman.blixtvik.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbZLZMIT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Dec 2009 07:08:19 -0500
Received: from cheetah.psv.nu (129-232-96-87.cust.blixtvik.se [87.96.232.129])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by batman.blixtvik.net (Postfix) with ESMTP id 2C8B57F835C
	for <linux-wireless@vger.kernel.org>; Sat, 26 Dec 2009 12:50:26 +0100 (CET)
Received: from cheetah.psv.nu (localhost.localdomain [127.0.0.1])
	by cheetah.psv.nu (8.13.8/8.13.8) with ESMTP id nBQBoQIF017943
	for <linux-wireless@vger.kernel.org>; Sat, 26 Dec 2009 12:50:26 +0100
Received: from localhost (petersv@localhost)
	by cheetah.psv.nu (8.13.8/8.13.8/Submit) with ESMTP id nBQBoOEs017940
	for <linux-wireless@vger.kernel.org>; Sat, 26 Dec 2009 12:50:26 +0100
Date: Sat, 26 Dec 2009 12:50:23 +0100 (CET)
From: Peter Svensson <petersv@psv.nu>
To: linux-wireless@vger.kernel.org
Subject: Compat-wireless bleeding-edge daily builds broken since 2009-12-11
Message-ID: <Pine.LNX.4.64.0912261245080.5112@cheetah.psv.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The bleeding edge nightly snapshopts in 
  http://wireless.kernel.org/download/compat-wireless-2.6/
are not updated since the compat-bluetooth were introduced (I think) on 
2009-12-11. 

When built from the git sources the driver works very nicely, and much 
more stable than the last drop on 2009-12-11.

Peter

