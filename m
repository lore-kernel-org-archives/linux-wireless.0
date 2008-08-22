Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lirone.symas.net ([64.71.152.235]:44522 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689AbYHVVFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2008 17:05:53 -0400
Message-ID: <48AF209A.4080805@symas.com> (sfid-20080822_230607_820820_7CAC7BD0)
Date: Fri, 22 Aug 2008 13:24:58 -0700
From: Howard Chu <hyc@symas.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
CC: linux-wireless@vger.kernel.org
Subject: compat-2.6: ath9k driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just got a new HP dv5z laptop with a/b/g/n wifi adapter; it claims to be an 
AR5009. Googling for the PCI ID (0x002a) matched it up with AR9280, which led 
me to the ath9k driver. It's not currently provided with the compat-2.6 tree 
but I pulled a copy from the wireless-testing branch and added it to my compat 
tree.

It needed 3-4 definitions to be added to <linux/list.h> but otherwise compiled 
OK and it's now working fine for me in 2.6.26.3. Did you already have plans to 
include this driver, should I post my diffs?
-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
