Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56474 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933329Ab1ESOMl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2011 10:12:41 -0400
Received: by vws1 with SMTP id 1so1937709vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 May 2011 07:12:40 -0700 (PDT)
Message-ID: <4DD52555.8020300@lwfinger.net> (sfid-20110519_161246_341248_338F74A5)
Date: Thu, 19 May 2011 09:12:37 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: Re: [PATCH 1/2] ath9k: unify edma and non-edma tx code, improve tx
 fifo handling
References: <1305719964-44292-1-git-send-email-nbd@openwrt.org> <20110518190733.GA2543@tuxdriver.com> <4DD4DC13.5020006@openwrt.org>
In-Reply-To: <4DD4DC13.5020006@openwrt.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/19/2011 04:00 AM, Felix Fietkau wrote:
> On 2011-05-18 9:07 PM, John W. Linville wrote:
>> CC [M] drivers/net/wireless/ath/ath9k/xmit.o
>> drivers/net/wireless/ath/ath9k/xmit.c: In function ‘ath_tx_edma_tasklet’:
>> drivers/net/wireless/ath/ath9k/xmit.c:2199:18: warning: ‘txq’ may be used
>> uninitialized in this function
>>
>> Please don't add warnings, especially not valid ones... :-)
> Odd, I wonder why my compiler didn't show me this warning when I worked on the
> patch, need to check my CFLAGS :)

If you figure out the CFLAGS needed to show the warnings, please share that 
information with the list.

Thanks,

Larry
