Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37098 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab2DCQTw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 12:19:52 -0400
Message-ID: <4F7B2321.2070005@candelatech.com> (sfid-20120403_181954_945985_DB1358F0)
Date: Tue, 03 Apr 2012 09:19:45 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: greearb@candelatech.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH 1/3] ath9k: Add tx-failed counter.
References: <1333469815-26146-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1333469815-26146-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/03/2012 09:16 AM, greearb@candelatech.com wrote:
> From: Ben Greear<greearb@candelatech.com>
>
> This counts any failure during getting packets into
> the DMA buffers, including out-of-memory, etc.

Errr, that should be 1/2.  I can re-send if
needed..might be other requests for changes
anyway...

Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

