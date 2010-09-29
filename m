Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47921 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab0I2RDh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 13:03:37 -0400
Message-ID: <4CA3715F.2080706@candelatech.com>
Date: Wed, 29 Sep 2010 10:03:27 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: greearb@candelatech.com
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v7] ath5k: Allow ath5k to support virtual STA and AP interfaces.
References: <1285779730-29815-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1285779730-29815-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/29/2010 10:02 AM, greearb@candelatech.com wrote:
> From: Ben Greear<greearb@candelatech.com>
>
> Support up to 4 virtual APs and as many virtual STA interfaces
> as desired.
>
> This patch is ported forward from a patch that Patrick McHardy
> did for me against 2.6.31.
>
> Signed-off-by: Ben Greear<greearb@candelatech.com>
> ---
> v7 ->  v8:  Add Bruno Randolf's adhoc improvements.
> v6 ->  v7:  Fix bug that assigned a beacon buffer to all vifs.
>        Tested creation of 128 stations, all passed traffic.
> v4 ->  v6:  Use tx_info's vif instead of NULL, assign beacon
>    buffers on device creation (for AP and ADHOC).  Clean up some
>    whitespace and un-used variables.
>
>    Did NOT change the beacon buffer linked list to an array.
>    It didn't seem to offer any benefits to me.

Errr, that was v8, forgot to change the title.

Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

