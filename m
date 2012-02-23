Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:57633 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab2BWX2f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 18:28:35 -0500
Date: Thu, 23 Feb 2012 18:28:25 -0500 (EST)
Message-Id: <20120223.182825.1031311733171854243.davem@davemloft.net> (sfid-20120224_002855_840966_96895832)
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, maciej.rutecki@gmail.com,
	florian@mickler.org, akpm@linux-foundation.org,
	torvalds@linux-foundation.org, kernel-testers@vger.kernel.org,
	netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-pm@lists.linux-foundation.org, linux-scsi@vger.kernel.org,
	linux-wireless@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: 3.3-rc4+: Reported regressions from 3.2
From: David Miller <davem@davemloft.net>
In-Reply-To: <y44pDJ8xoDC.A.08E.h8rRPB@chimera>
References: <y44pDJ8xoDC.A.08E.h8rRPB@chimera>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Thu, 23 Feb 2012 23:51:20 +0100 (CET)

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42776
> Subject		: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
> Submitter	: Meelis Roos <mroos@linux.ee>
> Date		: 2012-02-13 7:45 (11 days old)
> Message-ID	: <alpine.SOC.1.00.1202130942030.1488@math.ut.ee>
> References	: http://marc.info/?l=linux-kernel&m=132911916331615&w=2

Potential workaround/fix at:

http://marc.info/?l=linux-kernel&m=132993294018762&w=2
