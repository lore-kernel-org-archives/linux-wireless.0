Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53661 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab3EOWx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 18:53:26 -0400
Message-ID: <519411E4.6060505@candelatech.com> (sfid-20130516_005330_319941_BD5284E7)
Date: Wed, 15 May 2013 15:53:24 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Cyril Seg <cyrilseg@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: STA doesn't support ACM for QoS
References: <loom.20130516T003547-82@post.gmane.org>
In-Reply-To: <loom.20130516T003547-82@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/15/2013 03:42 PM, Cyril Seg wrote:
> Hello ,
>
> In my testbed, there is an AP that works with ath9k_htc and hostapd and there
> also are 2 STAs that work with ath9k_htc.
> Video flows aren't in the good priority, they are in Best_Effort.
> But if I enable the ACM parameter for VIDEO and BEST EFFORT, video flows are
> now in BACKGROUND priority.
> STAs doesn't support the admission control ...
>
> Does someone have a solution ?
>
> I work with Kali Linux, kernel 3.7

See what ToS bits are in your video frames.   Some definitions
of ToS had low values for video (32), but wifi requires different
settings (something like 128).

Thanks,
Ben


>
> Thanks,
>
> Cyril Segretain
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

