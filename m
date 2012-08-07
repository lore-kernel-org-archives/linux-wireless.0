Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:43284 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757170Ab2HGCfB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 22:35:01 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Fengguang Wu <fengguang.wu@intel.com>,
	Avinash Patil <patila@marvell.com>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Kiran Divekar <dkiran@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 6 Aug 2012 19:33:37 -0700
Subject: RE: [wireless-testing:master 53/59]
 drivers/net/wireless/mwifiex/uap_event.c:251:11: warning: comparison of
 distinct pointer types lacks a cast
Message-ID: <477F20668A386D41ADCC57781B1F7043083AE3DA2C@SC-VEXCH1.marvell.com> (sfid-20120807_043509_453561_C9948FBE)
References: <20120807005524.GD9903@localhost>
In-Reply-To: <20120807005524.GD9903@localhost>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Fengguang,

> drivers/net/wireless/mwifiex/uap_event.c: In function 'mwifiex_process_uap_event':
> drivers/net/wireless/mwifiex/uap_event.c:251:11: warning: comparison of distinct pointer types lacks
> a cast [enabled by default]

Thanks for reporting this warning.
Could you please share your gcc version (or ppc toolchain version) with me?

Thanks,
Bing

