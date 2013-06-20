Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:2495 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965461Ab3FTOAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jun 2013 10:00:12 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Kirshenbaum Erez <erezk@wilocity.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] wil6210: add HW write-back option in TX descriptor
Date: Thu, 20 Jun 2013 17:00:08 +0300
Message-ID: <4290372.7VeYom9MqU@lx-vladimir> (sfid-20130620_160017_077050_8FBE8925)
In-Reply-To: <1371732340-4149-1-git-send-email-erezk@wilocity.com>
References: <1371732340-4149-1-git-send-email-erezk@wilocity.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, June 20, 2013 03:45:40 PM Kirshenbaum Erez wrote:
> Map BIT 9 in TX DMA DWARD 0 as HW write back option.
> We must turn on this option in the last TX descriptor,
> this is required for old HW compatability.
> This option indicate to HW that WB is required for this descriptor.
> 
> Signed-off-by: Kirshenbaum Erez <erezk@wilocity.com>

Here is my
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Thanks for this.
