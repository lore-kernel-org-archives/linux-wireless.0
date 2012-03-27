Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2687 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541Ab2C0GIU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 02:08:20 -0400
Message-ID: <4F71594F.4070907@qca.qualcomm.com> (sfid-20120327_080832_973251_5307465B)
Date: Tue, 27 Mar 2012 09:08:15 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Joyce Chain <joycechien0306@gmail.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: ask AR6003 build for Linux Kernel 3.0.8 or newer
References: <CA+eKVEmL83p8zrhbAE5WDLnO-svodEExTQpwcVJLhBLLixCf5g@mail.gmail.com>	<CA+eKVEnGQHZbtGVoz7BuDUf5QDWCmz7PwenU6E4RXNdVNBdi9A@mail.gmail.com>	<4F7152CE.7060500@qca.qualcomm.com> <CA+eKVEkOvuWoSeGtCsCV6uvKQy8tYY9w4CFOV9oRm9XZ7BVwKw@mail.gmail.com>
In-Reply-To: <CA+eKVEkOvuWoSeGtCsCV6uvKQy8tYY9w4CFOV9oRm9XZ7BVwKw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/27/2012 09:00 AM, Joyce Chain wrote:
> May I ask the other question -- Do you know the special team or body to
> maintain AR6kSDK.build_3.1_RC.465?
> Because the structures of the source code are too many different places
> between AR6kSDK and ath6kl.
> I can not build ath6kl source code(set CONFIG_ATH6K_LEGACY to y) on the
> Linux kernel inside for our target.

The future is ath6kl and that's what I recommend to use. I don't have
any knowledge about AR6kSDK, sorry.

Kalle
