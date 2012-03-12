Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63600 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab2CLJlN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 05:41:13 -0400
Message-ID: <4F5DC4B1.5070404@qca.qualcomm.com> (sfid-20120312_104118_700671_7B6E673E)
Date: Mon, 12 Mar 2012 15:11:05 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<ath9k-devel@lists.ath9k.org>, <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>
Subject: Re: [ath9k-devel] [RFC] ath9k_hw: Fix chip revision checks
References: <1331531853-5043-1-git-send-email-mohammed@qca.qualcomm.com> <4F5DBB8B.1070000@openwrt.org> <4F5DBED4.4050500@qca.qualcomm.com>
In-Reply-To: <4F5DBED4.4050500@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> while adding some new code while AR_9280_SREV_20 later was not in
> uniform with the other chipset macros. i should have just checked with
> git annotate reg.h could have found your commit.

Felix had said this could be better done by using AR_SREV_9280_OR_LATER 
macro with the corresponding changes to be effect in the hardware code.
thanks.

-- 
thanks,
shafi
