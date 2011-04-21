Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3794 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268Ab1DURcb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 13:32:31 -0400
To: "Joe Perches" <joe@perches.com>
cc: "Roland Vossen" <rvossen@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] staging: brcm80211: replaced WL_NONE with
 no_printk
References: <1303383725-1440-1-git-send-email-rvossen@broadcom.com>
 <1303383725-1440-2-git-send-email-rvossen@broadcom.com>
 <1303403680.24766.55.camel@Joe-Laptop> <op.vuasnofu3ri7v4@arend-laptop>
 <1303406040.24766.65.camel@Joe-Laptop>
Date: Thu, 21 Apr 2011 19:32:16 +0200
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Message-ID: <op.vuatn2bk3ri7v4@arend-laptop>
In-Reply-To: <1303406040.24766.65.camel@Joe-Laptop>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 21 Apr 2011 19:14:00 +0200, Joe Perches <joe@perches.com> wrote:

> On Thu, 2011-04-21 at 19:10 +0200, Arend van Spriel wrote:
>> If you want to debug a specific source file you could do following in  
>> that
>> particular source file:
>> #undef no_printk
>> #define no_printk  printk
>> Not sure whether that is the intended use here.
>
> True, but that's entirely backwards
> and not very sensible either.
>
> For that you use pr_debug/dev_dbg/etc
> and then add #define DEBUG.

I see. I think WL_NONE was used like this and we mistakenly decided  
no_printk was the equivalent. Thanks for the clarifications.

Gr. AvS
-- 
"The world is indeed comic, but the joke is on mankind." — H.P. Lovecraft

