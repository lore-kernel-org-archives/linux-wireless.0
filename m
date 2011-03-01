Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lider.pardus.org.tr ([193.140.100.216]:33296 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab1CAVnk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 16:43:40 -0500
Message-ID: <4D6D688C.7090605@pardus.org.tr>
Date: Tue, 01 Mar 2011 23:43:40 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-wireless@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH] staging: rtl8192e: Fix incorrect netif_stop_queue usage
 warning
References: <1298964192-13074-1-git-send-email-ozan@pardus.org.tr> <20110301211523.GA19958@kroah.com>
In-Reply-To: <20110301211523.GA19958@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01.03.2011 23:15, Greg KH wrote:
> On Tue, Mar 01, 2011 at 09:23:12AM +0200, Ozan Çağlayan wrote:
>> The TX queues are allocated inside register_netdev.
>> It doesn't make any sense to stop the queue before
>> allocation.
>>
>> Signed-off-by: Ozan Çağlayan<ozan@pardus.org.tr>
>> ---
>>   drivers/staging/rtl8192e/r8192E_core.c |    1 -
>>   1 files changed, 0 insertions(+), 1 deletions(-)
>
> This patch doesn't apply, what tree did you make it against?

hmm, weird it was on top of an up-to-date linux-2.6 tree.

-- 
Pardus Linux
http://www.pardus.org.tr/eng
