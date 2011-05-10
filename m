Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53695 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab1EJT6T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 15:58:19 -0400
Message-ID: <4DC998D3.1000209@candelatech.com> (sfid-20110510_215822_838750_6D9D573D)
Date: Tue, 10 May 2011 12:58:11 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: greearb@candelatech.com
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC ] wireless: Support can-scan-one logic.
References: <1305057374-9875-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1305057374-9875-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/10/2011 12:56 PM, greearb@candelatech.com wrote:
> From: Ben Greear<greearb@candelatech.com>
>
> Enable this by passing a -1 for a scan frequency.
>
> When enabled, the system will only scan the current active
> channel if at least one VIF is actively using it.  If no
> VIFS are active or this flag is disabled, then default
> behaviour is used.
>
> This helps when using multiple STA interfaces that otherwise might
> constantly be trying to scan all channels.

A more intrusive version of this patch was previously NAK'd, but
since the scan and off-channel optimizations went in, I thought
this might have a chance.

I'll not send again if NAK'd this time.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

