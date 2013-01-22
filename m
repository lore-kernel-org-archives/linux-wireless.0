Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49347 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267Ab3AVVb7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2013 16:31:59 -0500
Message-ID: <50FF054A.1050607@openwrt.org> (sfid-20130122_223203_020894_ABCD986A)
Date: Tue, 22 Jan 2013 22:31:54 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 5/8] ath9k_hw: make various ar5416/ar91xx rf banks const
References: <1358704319-81749-1-git-send-email-nbd@openwrt.org> <1358704319-81749-2-git-send-email-nbd@openwrt.org> <1358704319-81749-3-git-send-email-nbd@openwrt.org> <1358704319-81749-4-git-send-email-nbd@openwrt.org> <1358704319-81749-5-git-send-email-nbd@openwrt.org> <20130122210518.GE13719@tuxdriver.com>
In-Reply-To: <20130122210518.GE13719@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-01-22 10:05 PM, John W. Linville wrote:
> This fails to apply against wireless-next...
It depends on "ath9k_hw: clean up RF Bank6 handling on AR5416/AR91xx",
which I sent as marked for 3.8, but was meant for 3.9.

- Felix

