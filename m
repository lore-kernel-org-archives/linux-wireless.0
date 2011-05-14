Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sx003.ddc-nl0105.slb.com ([199.6.154.22]:49970 "EHLO
	nl0105mta01.mail.slb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab1ENHLK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 May 2011 03:11:10 -0400
Received: from nl0105mta01.mail.slb.com (localhost.localdomain [127.0.0.1])
	by localhost (Postfix) with SMTP id 5E52259024D
	for <linux-wireless@vger.kernel.org>; Sat, 14 May 2011 07:01:12 +0000 (GMT)
Received: from NL0230MBX01N1.DIR.slb.com (nl0230mbx01n1.dir.slb.com [199.6.132.5])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by nl0105mta01.mail.slb.com (Postfix) with ESMTPS id 18E7A59022F
	for <linux-wireless@vger.kernel.org>; Sat, 14 May 2011 07:01:12 +0000 (GMT)
From: John Frankish <j-frankish@slb.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: iw connect syntax for wep
Date: Sat, 14 May 2011 07:01:10 +0000
Message-ID: <654DF80AD31A344E93DBCC6280BD6DEF19352F42@NL0230MBX08N1.DIR.slb.com> (sfid-20110514_091121_246970_E2FF9308)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The iw documentation and "iw --help" states the following for establishing a wep connection:

iw wlan0 connect foo keys 0:abcde d:1:0011223344

What command syntax is supposed to be used when connecting to an ap using a single wep code consisting of 13 hex pairs?

"iw wlan0 connect ssid keys 1:00112233445566778899AABBCC" does not work

Thanks
John
