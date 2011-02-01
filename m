Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:59948 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab1BAGjS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 01:39:18 -0500
To: David Gnedt <david.gnedt@davizone.at>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: Re: [PATCH 00/18] wl1251: feature ports / monitor mode / packet injection
References: <4D45A583.3060605@davizone.at> <4D45B7B2.40001@davizone.at>
	<87r5btdsb8.fsf@purkki.adurom.net> <4D473E72.3050307@davizone.at>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 01 Feb 2011 08:39:14 +0200
In-Reply-To: <4D473E72.3050307@davizone.at> (David Gnedt's message of "Mon\, 31 Jan 2011 23\:57\:54 +0100")
Message-ID: <87wrlkcl7x.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Gnedt <david.gnedt@davizone.at> writes:

> One thing I haven't included in this patchset is the netlink
> interface from the fremantle code for NVS loading because I thought
> it wouldn't be accepted anyway.

Correct, it's definitely not for upstream. nl80211 now has testmode
interface which can be used for that, but as wl1251 hardware is so old
already I doubt anyone has any interest on.

I have now read and commented some of your patches, I will go through
the rest today. But 18 patches in a patchset is quite a lot. To make
it easier to review and manage the patches I would recommend to split
them to smaller and logical patchsets.

-- 
Kalle Valo
