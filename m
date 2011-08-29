Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54083 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab1H2RmU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 13:42:20 -0400
Message-ID: <4E5BCF77.2030701@openwrt.org> (sfid-20110829_194223_372086_1B401EE2)
Date: Mon, 29 Aug 2011 19:42:15 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	rmanohar@qca.qualcomm.com
Subject: Re: [PATCH v6 2/3] ath9k: merge reset related functions
References: <1314614783-6133-1-git-send-email-nbd@openwrt.org> <1314614783-6133-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1314614783-6133-2-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-08-29 12:46 PM, Felix Fietkau wrote:
> reduces unnecessary code duplication
>
> Signed-off-by: Felix Fietkau<nbd@openwrt.org>
I just found a potential 'scheduling while atomic' issue. Will send a v7

- Felix
