Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44450 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752081AbdLQKnO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Dec 2017 05:43:14 -0500
Subject: Re: [PATCH 09/14] mt76x2: remove MAC address limitation for multi-vif
 setups
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
References: <20171214153918.43774-1-nbd@nbd.name>
 <20171214153918.43774-10-nbd@nbd.name>
Message-ID: <33ad3a83-bc51-ebf8-fc67-5cbacc7e07f4@nbd.name> (sfid-20171217_114338_135770_81326433)
Date: Sun, 17 Dec 2017 11:43:12 +0100
MIME-Version: 1.0
In-Reply-To: <20171214153918.43774-10-nbd@nbd.name>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-12-14 16:39, Felix Fietkau wrote:
> The hardware has a separate set of registers to configure a
> per-interface MAC address.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
Please drop patches 09-11, I'm currently investigating a performance
regression. The rest should be fine.

- Felix
