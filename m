Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2638 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556Ab1AXNXN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 08:23:13 -0500
To: "Jamie Kitson" <jamie@kitten-x.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Brett Rudley" <brudley@broadcom.com>
Subject: Re: Kernel Panic wlc_mac80211.c Line 6093
References: <AANLkTikam0zcxe00UCT4BDQMmrJcPKf1Hbt6=PBokpga@mail.gmail.com>
 <4D3B0390.5070108@broadcom.com>
 <AANLkTinwPrar6ZBhSALBif8__4mHHsKuDYKsgr4FDqtu@mail.gmail.com>
Date: Mon, 24 Jan 2011 14:22:54 +0100
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Message-ID: <op.vptd4dqs3ri7v4@arend-laptop>
In-Reply-To: <AANLkTinwPrar6ZBhSALBif8__4mHHsKuDYKsgr4FDqtu@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jamie,

On Mon, 24 Jan 2011 13:45:47 +0100, Jamie Kitson <jamie@kitten-x.com>  
wrote:

>> Rereading the whole thread I noticed the PREEMPT in your uname message.  
>> Does
>> this mean you are running with CONFIG_PREEMPT (Preemptible Kernel)?
>
> Apparently so. I'm using the stock Arch kernel.
>
>> This may not be supported by this driver.
>
> Ok, how would I find out for sure?
>
Try a non-preemptible kernel? I will discuss it over here and get back  
with a definite response. Maybe it is a new candidate for our todo list.

Gr. AvS

-- 
Using Opera's revolutionary email client: http://www.opera.com/mail/

