Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34588 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509Ab1BOTAg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 14:00:36 -0500
Date: Tue, 15 Feb 2011 13:54:00 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: David Gnedt <david.gnedt@davizone.at>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	Grazvydas Ignotas <notasas@gmail.com>,
	"Denis 'GNUtoo' Carikli" <GNUtoo@no-log.org>
Subject: Re: [PATCH 08/18] wl1251: implement hardware ARP filtering
Message-ID: <20110215185359.GG2557@tuxdriver.com>
References: <4D45A5C7.8000000@davizone.at>
 <4D45B7C6.4030709@davizone.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4D45B7C6.4030709@davizone.at>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 30, 2011 at 08:11:02PM +0100, David Gnedt wrote:
> Update hardware ARP filter configuration on BSS_CHANGED_ARP_FILTER
> notification from mac80211.
> Ported from wl1271 driver.
> 
> Signed-off-by: David Gnedt <david.gnedt@davizone.at>

I merged part of this series (i.e. the parts Kalle ACKed).  There still
remain some that Kalle requested to be changed and maybe some (like
this one?) that Kalle hasn't commented on at all.

I'm dropping the patches from this series that have not already
been merged.  Please resubmit any (with the requested changes) that
you still think are appropriate.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
