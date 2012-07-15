Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40135 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab2GORxc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jul 2012 13:53:32 -0400
Message-ID: <50030397.2070602@openwrt.org> (sfid-20120715_195335_995496_926CD271)
Date: Sun, 15 Jul 2012 19:53:27 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: Re: [PATCH v2 05/12] ath9k_hw: remove redundant arguments to INIT_INI_ARRAY
References: <1342105451-42297-1-git-send-email-nbd@openwrt.org> <1342105451-42297-2-git-send-email-nbd@openwrt.org> <1342105451-42297-3-git-send-email-nbd@openwrt.org> <1342105451-42297-4-git-send-email-nbd@openwrt.org> <1342105451-42297-5-git-send-email-nbd@openwrt.org>
In-Reply-To: <1342105451-42297-5-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-07-12 5:04 PM, Felix Fietkau wrote:
> The row/column sizes can be derived from the array argument within the macro
> itself, which is less error prone. In a few cases the supplied column size
> was actually wrong.
This patch no longer applies since Mohammed Shafi's WoW work was merged.
I'll send a v3.

- Felix
