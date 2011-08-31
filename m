Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36140 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab1HaHpZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 03:45:25 -0400
Message-ID: <4E5DE691.6060506@qca.qualcomm.com> (sfid-20110831_094530_450332_A0F5AFF9)
Date: Wed, 31 Aug 2011 10:45:21 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 00/22] ath6kl: AP mode and P2P
References: <1314730691-12089-1-git-send-email-jouni@qca.qualcomm.com>
In-Reply-To: <1314730691-12089-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/30/2011 09:57 PM, Jouni Malinen wrote:
> This set of patches adds preliminary support for AP mode and P2P
> operations into ath6kl. Since these require a new firmware build
> and more testing, the patches to actually enable either AP or P2P
> modes are not included in the series. These will be submitted
> after some more testing.
> 
> v2:
> - address review comments
> - add couple of additional cleanup/sparse patches for things that came
>   up during the review

Thanks, all 22 patches applied. But I can't push yet as
master.kernel.org is down for maintenance.

Kalle
