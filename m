Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:14012 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab3FILZe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jun 2013 07:25:34 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wil6210: fix name of tracing config option
Date: Sun, 9 Jun 2013 14:25:30 +0300
Message-ID: <11240049.FTSjXXmOrX@lx-vladimir> (sfid-20130609_132555_075405_F15D2B3D)
In-Reply-To: <1370776205-3755-1-git-send-email-hauke@hauke-m.de>
References: <1370776205-3755-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, June 09, 2013 01:10:05 PM Hauke Mehrtens wrote:
> Tracing in wil6210 is activated with WIL6210_TRACING and not with
> ATH6KL_TRACING, this is used for the ath6kl driver. Rename the config
> option.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Thanks for finding this.

Acked-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

