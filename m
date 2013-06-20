Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22052 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893Ab3FTOr4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jun 2013 10:47:56 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Kirshenbaum Erez <erezk@wilocity.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/1] wil6210: set vring index for all descriptors
Date: Thu, 20 Jun 2013 17:47:53 +0300
Message-ID: <6443787.Wu8jvXyzrb@lx-vladimir> (sfid-20130620_164800_173169_3F2BE9BC)
In-Reply-To: <1371734684-4453-1-git-send-email-erezk@wilocity.com>
References: <1371734684-4453-1-git-send-email-erezk@wilocity.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, June 20, 2013 04:24:44 PM Kirshenbaum Erez wrote:
> The vring index (MAC queue id) must be set in all TX descriptors
> otherwise HW will fail to release descriptors for a specific vring
> (disconnect or vring switch flows).
> This is normally occurs when fragmentation required, if vring index
> will not be the same for all SKB descriptors HW will fail to flush
> this MAC queue.
> 
> Signed-off-by: Kirshenbaum Erez <erezk@wilocity.com>
> 
Here is my
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Thanks.
