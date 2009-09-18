Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:17756 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbZIRMTM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2009 08:19:12 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id E66644B00A
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2009 14:19:15 +0200 (CEST)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SW7VJfS7wVl3 for <linux-wireless@vger.kernel.org>;
	Fri, 18 Sep 2009 14:19:15 +0200 (CEST)
Received: from lin01.mn-solutions.de (pD95F87DB.dip0.t-ipconnect.de [217.95.135.219])
	by mx51.mymxserver.com (Postfix) with ESMTP id 9A1314B00D
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2009 14:19:15 +0200 (CEST)
Received: from mnz66.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 4BE8C1E0036
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2009 14:19:06 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Life-time of scan-results?
Date: Fri, 18 Sep 2009 14:18:30 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909181418.30958.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While changing an AP between different SSIDs and encryptions, I
get from time to time this scan result back:

1253272186.504636: ##HS 0: 00:1b:d4:44:35:90 ssid='MNWPA' freq=2412
1253272186.504655: ##HS 1: 00:1b:53:11:dc:40 ssid='MNFUNK' freq=2412
1253272186.504672: ##HS 2: 00:13:19:80:da:30 ssid='XXXXX' freq=2412
1253272186.504688: ##HS 3: 00:13:19:80:da:30 ssid='MNHS' freq=2412


How can I entirely clear the scan results inside cfg80211/mac80211
from user-space?

Again this doesn't fit to any probe-responses.

-- 
http://www.holgerschurig.de
