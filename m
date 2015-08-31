Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:58660 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbbHaQbO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 12:31:14 -0400
Subject: Re: [PATCH] ath10k: Drop probe responses when too many are queued
To: Vivek Natarajan <nataraja@qti.qualcomm.com>, kvalo@qca.qualcomm.com
References: <1441019095-2364-1-git-send-email-nataraja@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <55E48151.9080609@candelatech.com> (sfid-20150831_183117_818252_72A081C1)
Date: Mon, 31 Aug 2015 09:31:13 -0700
MIME-Version: 1.0
In-Reply-To: <1441019095-2364-1-git-send-email-nataraja@qti.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 08/31/2015 04:04 AM, Vivek Natarajan wrote:
> In a noisy environment, when multiple interfaces are created,
> the management tx descriptors are fully occupied by the probe
> responses from all the interfaces. This prevents a new station
> from a successful association.
>
> Fix this by limiting the probe responses when the specified
> threshold limit is reached.

Is this useful when firmware supports management-tx over HTT (instead of WMI)?

Or just for WMI mgt?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

