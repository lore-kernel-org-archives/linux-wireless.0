Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:49312 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751432AbdAaS5W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 13:57:22 -0500
Subject: Re: [PATCH v2] ath10k: add support for controlling tx power to a
 station
To: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>,
        ath10k@lists.infradead.org
References: <1485888165-23504-1-git-send-email-arnagara@qti.qualcomm.com>
Cc: arnagara@codeaurora.org, linux-wireless@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <cbb69298-391d-b3d5-5a84-5792fe170f95@candelatech.com> (sfid-20170131_195726_074670_AD98F9D4)
Date: Tue, 31 Jan 2017 10:57:20 -0800
MIME-Version: 1.0
In-Reply-To: <1485888165-23504-1-git-send-email-arnagara@qti.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/31/2017 10:42 AM, Ashok Raj Nagarajan wrote:
> This patch will add the support to control the transmit power for traffic
> to a station associated with the AP. Userspace provide the transmit power
> value in mBm units and the allowed range is from 0 to 70. Underlying FW

How did you come up with 70 mBm as the limit.  This is only 7dBm?

I would expect it to match the range of normal tx-power which is likely up to
30 dBm or so on some NICs (not counting regulatory limit).

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
