Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11858 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757030Ab1LWMvg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 07:51:36 -0500
Message-ID: <4EF4794D.7000102@qca.qualcomm.com> (sfid-20111223_135143_712002_EF64AEFE)
Date: Fri, 23 Dec 2011 14:51:25 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Raja Mani <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>,
	Thirumalai Pachamuthu <tpachamu@qca.qualcomm.com>
Subject: Re: [PATCH 1/2] ath6kl: Avoid taking struct as argument in ath6kl_wmi_set_ip_cmd
References: <1324025664-4896-1-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1324025664-4896-1-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/16/2011 10:54 AM, Raja Mani wrote:
> In this way, caller is free to pass only the value of IP addr
> to configure.
> 
> In addition to this,
>   * 'ips' variable data type in struct wmi_set_ip_cmd is changed
>      from __le32 to __be32 in order to match network byte order.
>   *  ipv4_is_multicast() is used to validate multicast ip addr.
>   *  New argument if_idx is added to supply correct vif index
>      to ath6kl_wmi_cmd_send().
> 
> This will be used in the next patch.
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
> Signed-off-by: Thirumalai Pachamuthu <tpachamu@qca.qualcomm.com>

Thanks, both patches applied.

Kalle
