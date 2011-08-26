Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38322 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037Ab1HZNbe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 09:31:34 -0400
Date: Fri, 26 Aug 2011 19:02:01 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath9k_hw: Fix slottime with coverage class
Message-ID: <20110826133200.GA17491@vmraj-lnx.users.atheros.com> (sfid-20110826_153138_408833_5455C7DA)
References: <1314283522-6143-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1314283522-6143-2-git-send-email-rmanohar@qca.qualcomm.com>
 <4E566BE3.3080907@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4E566BE3.3080907@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 25, 2011 at 05:36:03PM +0200, Felix Fietkau wrote:
> On 2011-08-25 4:45 PM, Rajkumar Manoharan wrote:
> >The commit b6ba41bb27eb9810d54e2301355ce56fd0e94a1a updates
> >acktimeout wihout updating slottime when coverage class is defined
> >as per IEEE 802.11-2007 17.3.8.6.
> >
> >Signed-off-by: Rajkumar Manoharan<rmanohar@qca.qualcomm.com>
> I intentionally left the coverage class out of the hw slot time
> setting, because increasing slot time too much causes severe
> throughput issues. I've observed this even with relatively minor
> coverage class settings (e.g. for 2 km) on AR9160 and AR9280. I
> haven't tested AR9380 though.
>
Which band have you tested on AR9280?

--
Rajkumar
