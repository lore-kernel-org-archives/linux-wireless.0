Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:38543 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbZIWM34 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2009 08:29:56 -0400
MIME-Version: 1.0
In-Reply-To: <1253691283.4458.38.camel@johannes.local>
References: <1253662724-16497-1-git-send-email-tomas.winkler@intel.com>
	 <1253662724-16497-2-git-send-email-tomas.winkler@intel.com>
	 <1253689036.4458.22.camel@johannes.local>
	 <1ba2fa240909230023v17fe2b49v4981d464dba469ed@mail.gmail.com>
	 <1253691283.4458.38.camel@johannes.local>
Date: Wed, 23 Sep 2009 15:29:59 +0300
Message-ID: <1ba2fa240909230529t13f202f5k9c8742025ca63aa8@mail.gmail.com>
Subject: Re: [PATCH 1/3] iwmc3200top: Add Intel Wireless MultiCom 3200 top
	driver.
From: Tomas Winkler <tomasw@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: davem@davemloft.net, linville@tuxdriver.com,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-mmc@vger.kernel.org, yi.zhu@intel.com,
	inaky.perez-gonzalez@intel.com, cindy.h.kao@intel.com,
	guy.cohen@intel.com, ron.rindjunsky@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 23, 2009 at 10:34 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2009-09-23 at 10:23 +0300, Tomas Winkler wrote:
>
>> From HW perspective your assumption is not exactly correct. All the
>> devices are visible on the SDIO bus but they are not operational
>> (probe won't succeed) until TOP download the firmware and kicks the
>> devices. From SW perspective to create another bus layer is an option.
>> I'm not sure if it's not more complicated one.
>
> Ah, ok, so it is quite different. Not sure how sdio probing works, so I
> guess I can't say much here.

This is not about SDIO probing this is rather unusual HW design.
Anyhow all comments and ideas are welcome.

Thanks
Tomas
