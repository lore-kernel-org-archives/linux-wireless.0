Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55268 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbbBZMFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 07:05:22 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH 9/9] wil6210: Align Rx buffers on 4*n+2
References: <1424001758-29529-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1424001758-29529-10-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<2609868.jbmxKLRXsk@lx-wigig-72>
Date: Thu, 26 Feb 2015 14:05:14 +0200
In-Reply-To: <2609868.jbmxKLRXsk@lx-wigig-72> (Vladimir Kondratiev's message
	of "Thu, 19 Feb 2015 08:47:11 +0200")
Message-ID: <874mq8ev45.fsf@kamboji.qca.qualcomm.com> (sfid-20150226_130525_758484_A35B96E4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com> writes:

> On Sunday, February 15, 2015 02:02:38 PM Vladimir Kondratiev wrote:
>> For the normal (non-sniffer) mode of operation, align Rx buffer
>> on 4*n+2, so IP header (after 14 bytes of Ethernet header)
>> will start dword aligned. This accelerated IP stack a little bit.
>> 
>> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
>> 
> Kalle,
>
> please do not apply this patch. I found last minute problem with it - 
> hardware is not always happy.
>
> For now, drop it please. I will do more testing and re-submit this
> patch if everything wends OK.

Ok, I dropped this patch. Patches 1-8 are still on my queue.

-- 
Kalle Valo
