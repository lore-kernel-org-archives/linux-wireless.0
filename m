Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18248 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab2BHJak (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 04:30:40 -0500
Message-ID: <4F3240B8.30601@qca.qualcomm.com> (sfid-20120208_103046_725131_F92F1BB4)
Date: Wed, 8 Feb 2012 11:30:32 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath6kl: store firmware logs in skbuffs
References: <20120206062327.20231.11602.stgit@localhost6.localdomain6>
In-Reply-To: <20120206062327.20231.11602.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/06/2012 08:23 AM, Kalle Valo wrote:
> Currently firmware logs are stored in a circular buffer, but this was
> not very flexible and fragile. It's a lot easier to store logs to struct
> skbuffs and store them in a skb queue. Also this makes it possible
> to easily increase the buffer size, even dynamically if we so want (but
> that's not yet supported).
> 
>>From user space point of view nothing should change.
> 
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Both patches applied.

Kalle
