Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from host.zinkconsulting.com ([209.59.162.221]:38282 "EHLO
	host.zinkconsulting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab0JOXiz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 19:38:55 -0400
Received: from c-76-105-209-150.hsd1.or.comcast.net ([76.105.209.150] helo=[192.168.77.10])
	by host.zinkconsulting.com with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.69)
	(envelope-from <galenz@zinkconsulting.com>)
	id 1P6sn0-0003aJ-Dj
	for linux-wireless@vger.kernel.org; Fri, 15 Oct 2010 18:30:14 -0400
Subject: Complexity of Adding 5/10 MHz Channel Support
From: Galen <galenz@zinkconsulting.com>
Content-Type: text/plain; charset=us-ascii
Message-Id: <1A7DEBB8-6337-4551-9F21-14C20E13B86B@zinkconsulting.com>
Date: Fri, 15 Oct 2010 15:30:12 -0700
To: linux-wireless@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1081)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Can anybody give me an idea the extent and complexity of adding support for 5/10 MHz channels in mac80211?

Several different radios (including those supported by ath5k and ath9k) have the hardware capability to operate at 5 MHz. Obviously, support in those drivers is a separate issue, but it is my understanding that mac80211 must first support 5/10 MHz channels.

Thoughts would be appreciated.

-Galen