Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:16779 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995Ab3JDN4U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Oct 2013 09:56:20 -0400
Date: Fri, 4 Oct 2013 15:57:41 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Kevin Lo <kevlo@kevlo.org>, g@localhost.localdomain
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH] rt2x00: rt2800lib: fix RF registers for
 RT5390/RT5392
Message-ID: <20131004135741.GB22592@localhost.localdomain> (sfid-20131004_155623_948084_B2676ECA)
References: <524BEB7A.8040508@kevlo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <524BEB7A.8040508@kevlo.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 02, 2013 at 05:46:34PM +0800, Kevin Lo wrote:
> Update rf registers to use the same values that the MediaTek/Ralink
> reference driver DPO_RT5572_LinuxSTA_2.6.1.3_20121022 uses.
> 
> References:
>   RF5390RegTable in chips/rt5390.c
>   RF5392RegTable in chips/rt5390.c
> 
> Tested on TP-Link TL-WN727N and D-Link DWA-140 Rev.b3 usb wifi dongles.
> 
> Signed-off-by: Kevin Lo <kevlo@kevlo.org>

Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

