Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59665 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbaLFD7s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2014 22:59:48 -0500
Message-ID: <54827F30.8050005@candelatech.com> (sfid-20141206_045951_551910_41D7F2D3)
Date: Fri, 05 Dec 2014 19:59:44 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Peter Oh <poh@qca.qualcomm.com>, ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: unregister and remove frag_threshold callback
References: <1417799786-11391-1-git-send-email-poh@qca.qualcomm.com>
In-Reply-To: <1417799786-11391-1-git-send-email-poh@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 12/05/2014 09:16 AM, Peter Oh wrote:
> Setting fragmentation threshold has not been supported by
> any of firmware versions, hence unregister the callback and
> remove the function.

How hard is it to just fix the firmware instead?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
