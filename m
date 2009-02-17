Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:46396 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbZBQSwr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2009 13:52:47 -0500
Received: from [192.168.1.142] (S0106001cf062885c.vc.shawcable.net [24.82.150.230])
	by mail.holtmann.org (Postfix) with ESMTP id 9C3048B45D
	for <linux-wireless@vger.kernel.org>; Tue, 17 Feb 2009 19:52:50 +0100 (CET)
Subject: Missing link quality with wireless-testing
From: Marcel Holtmann <marcel@holtmann.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Tue, 17 Feb 2009 19:52:57 +0100
Message-Id: <1234896777.4678.7.camel@californication> (sfid-20090217_195251_321967_5E2E0AB8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

I have been running the wireless-testing kernel from yesterday and I
realized that something with the link quality values from scanning
results is broken. I know that you sent some patches in that area, but I
didn't really follow them. So it breaks WEXT and as much as we all
dislike them, we still can't break application without warning. So can
this be fixed inside mac80211 or do we have to fix this inside the
drivers and maybe just the iwlagn driver I am using needs an update?

Regards

Marcel


