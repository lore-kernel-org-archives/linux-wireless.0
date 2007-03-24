Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp166.iad.emailsrvr.com ([207.97.245.166]:40636 "EHLO
	smtp166.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbXCXSU3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Mar 2007 14:20:29 -0400
Message-ID: <46056BF3.9040801@gentoo.org>
Date: Sat, 24 Mar 2007 14:20:35 -0400
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: zd1211rw: reject AL2230S devices in Linux 2.6.21
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

I mentioned this in the email but maybe it got glanced over. I'd like 
commit 9b0190459fe0016c78fa1df8b36b11a58faaf55a in your tree to be 
considered for 2.6.21 because otherwise, these devices are detected 
incorrectly and silently don't work, appearing as a driver bug.

Thanks!
Daniel
