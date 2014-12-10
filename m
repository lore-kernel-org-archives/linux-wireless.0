Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:35347 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932527AbaLJUgq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2014 15:36:46 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH v3] wireless: Supporting of IFLA_INFO_KIND rtnl attribute
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1418163666-9206-1-git-send-email-vadim4j@gmail.com>
Date: Wed, 10 Dec 2014 21:36:44 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Message-Id: <507569F8-73EB-4159-8170-C25B06A99B2F@holtmann.org> (sfid-20141210_213650_062743_ECFF0097)
References: <1418163666-9206-1-git-send-email-vadim4j@gmail.com>
To: Vadim Kochan <vadim4j@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Vadim,

> It allows to identify the wlan kind of device for the user application,
> e.g.:
> 
>    # ip -d link
> 
>    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default
>        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00 promiscuity 0
>    2: enp0s25: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast state DOWN mode DEFAULT group default qlen 1000
>        link/ether XX:XX:XX:XX:XX:XX brd ff:ff:ff:ff:ff:ff promiscuity 0
>    3: wlp3s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
>        link/ether XX:XX:XX:XX:XX:XX brd ff:ff:ff:ff:ff:ff promiscuity 0
>        wlan
> 
> Signed-off-by: Vadim Kochan <vadim4j@gmail.com>
> ---
> net/wireless/core.c | 6 ++++++
> 1 file changed, 6 insertions(+)

for what its worth.

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel

