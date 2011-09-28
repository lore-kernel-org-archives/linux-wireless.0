Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51960 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755908Ab1I1XXj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 19:23:39 -0400
Message-ID: <4E83AC73.3090502@openwrt.org> (sfid-20110929_012344_999266_695C192B)
Date: Thu, 29 Sep 2011 01:23:31 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org
Subject: Re: [RFC] ath9k_hw: set is_pciexpress true for AR9480
References: <1317211660-3975-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1317211660-3975-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-09-28 2:07 PM, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>
> the AR_SREV register does not seems to indicate it properly though the
> other information like macVersion etc can be obtained properly
How about using AR_SREV_9300_20_OR_LATER(ah) instead to make sure that 
this works properly for future chips as well?

- Felix
