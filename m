Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39950 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934410Ab3BMQlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 11:41:49 -0500
Message-ID: <511BC243.8010409@candelatech.com> (sfid-20130213_174218_148417_8646BAF1)
Date: Wed, 13 Feb 2013 08:41:39 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 3.7.6+:  ath9k:  tx logic locks up after taking attenuation very
 high.
References: <511935F2.8080103@candelatech.com> <20761.34987.125000.908722@gargle.gargle.HOWL>
In-Reply-To: <20761.34987.125000.908722@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/11/2013 04:11 PM, Sujith Manoharan wrote:
> Ben Greear wrote:
>> axq-qnum:                    2          3         1         0
>> axq-depth:                   0          0         0         0
>> axq-ampdu_depth:             0          0         0         0
>> axq-stopped                  1          0         0         0
>> tx-in-progress               0          0         0         0
>> pending-frames             125          0         0         0
>
> The frames appear to be stuck in the pending queue.

Any ideas on what code to go poking at?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


