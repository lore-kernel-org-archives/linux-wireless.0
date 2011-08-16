Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35351 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581Ab1HPPbd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 11:31:33 -0400
Message-ID: <4E4A8D40.9040807@openwrt.org> (sfid-20110816_173136_483637_38A6C46A)
Date: Tue, 16 Aug 2011 08:31:12 -0700
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Alex Hacker <hacker@epn.ru>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k_hw: fix EIFS value to microseconds
References: <1313491300-11386-1-git-send-email-hacker@epn.ru>
In-Reply-To: <1313491300-11386-1-git-send-email-hacker@epn.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-08-16 3:41 AM, Alex Hacker wrote:
> The EIFS value read from AR_D_GBL_IFS_EIFS register in core clocks and then
> written back as microsecond value.
>
>
> Signed-off-by: Alex Hacker<hacker@epn.ru>
Acked-by: Felix Fietkau <nbd@openwrt.org>
