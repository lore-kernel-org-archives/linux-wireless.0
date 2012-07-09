Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7637 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab2GIGf3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 02:35:29 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20474.31597.88049.168563@gargle.gargle.HOWL> (sfid-20120709_083533_065654_798DCB1F)
Date: Mon, 9 Jul 2012 12:04:21 +0530
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: fix reset work check properly
In-Reply-To: <1341815640-6299-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1341815640-6299-1-git-send-email-rmanohar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
> Once the hw reset work is queued up and to bail out current
> execution properly, use HW_RESET bit ops instead of work_pending.
> As work_pending might return false when the queued work is in
> execution. So it is not correct to use the work utility for
> baining out.

I'll add this on top of my pending series and send it as a
single patch-bomb.

Sujith
