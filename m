Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10923 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757071Ab2ERPqd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 11:46:33 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20406.28318.161296.837397@gargle.gargle.HOWL> (sfid-20120518_174636_898752_EF641071)
Date: Fri, 18 May 2012 21:15:34 +0530
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 01/10] ath9k_hw: update ar9462 initval table to fix rx nfcal
In-Reply-To: <1337350053-15491-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1337350053-15491-1-git-send-email-rmanohar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
> The wrong ADC sample phase that happen between awake and
> network/full sleep will lead to improper rx noisefloor
> calibration.

Please send an update to initvals-tool.

Sujith
