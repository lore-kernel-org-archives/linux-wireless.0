Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:28888 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab3B0FgI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 00:36:08 -0500
Message-ID: <512D9B41.40608@qca.qualcomm.com> (sfid-20130227_063612_777879_BFD0BDD1)
Date: Wed, 27 Feb 2013 11:06:01 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Myoungje Kim <mjei78@gmail.com>
CC: <vthiagar@qca.qualcomm.com>, <sumathi@qca.qualcomm.com>,
	<kvalo@qca.qualcomm.com>,
	ath6kl-devel <ath6kl-devel@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ATH6KL: "Fix the byte alignment rule to avoid loss of
 bytes in a TCP segment"
References: <CABzs15B0TN=AgF+j9ZZL0yrfXwO31BJktRbXMwcwC5X2ricrkQ@mail.gmail.com>
In-Reply-To: <CABzs15B0TN=AgF+j9ZZL0yrfXwO31BJktRbXMwcwC5X2ricrkQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kim,

On 02/27/2013 10:47 AM, Myoungje Kim wrote:
> Hello
> I am Steven Kim.
>
> I found the driver bug which occur loss of some bytes on the TCP/IP stack.
> Please check this patch and pull-request on github.com.
> https://github.com/torvalds/linux/pull/27

please cc ath6kl-devel, Linux-wireless and send the patches
in git-send email. thanks!

>
> Best Regards
>
> Steven
>


-- 
thanks,
shafi
