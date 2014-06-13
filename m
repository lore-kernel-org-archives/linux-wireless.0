Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50726 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbaFMKoh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2014 06:44:37 -0400
Date: Fri, 13 Jun 2014 12:44:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: johannes.berg@intel.com, emmanuel.grumbach@intel.com,
	ilw@linux.intel.com, linux-wireless@vger.kernel.org
Subject: iwlwifi: very poor performance on 3.16-rc0
Message-ID: <20140613104435.GA4689@amd.pavel.ucw.cz> (sfid-20140613_124453_494311_FA9E1BEE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

On 6d87c225f5d82d29243dc124f1ffcbb0e14ec358 I get basically unusable
network.

Network manager connects to wireless network, and ping sometimes
returns a packet. One in 10 tabs load, dns usually does not work.

Thinkpad x60, 

03:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG
[Golan] Network Connection (rev 02)

Any ideas?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
