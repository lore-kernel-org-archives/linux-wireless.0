Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47199 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaDUPmj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2014 11:42:39 -0400
Message-ID: <53553C69.8090307@candelatech.com> (sfid-20140421_174245_151135_5447F7AA)
Date: Mon, 21 Apr 2014 08:42:33 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: John Tobias <john.tobias.ph@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Testing WMM
References: <CACUGKYPP9s1cSJEpuBfQxT9=xLY57t0-kLZ8D=X2gaVcXbC2Nw@mail.gmail.com>
In-Reply-To: <CACUGKYPP9s1cSJEpuBfQxT9=xLY57t0-kLZ8D=X2gaVcXbC2Nw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/18/2014 04:51 PM, John Tobias wrote:
> Hello Guys,
> 
> I would like to test the following WMM features of the wifi driver.
> 
> wmm_ac_vo
> wmm_ac_vi
> wmm_ac_be
> wmm_ac_bk
> 
> What tools did you use to test it?.

Use user-space app that can set IP ToS.  The OS/driver should put the
packets in the appropriate wmm queue.  Ensure that higher priority traffic
actually gets higher priority when over-driving each queue.

Thanks,
Ben

> 
> Regards,
> 
> john
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

