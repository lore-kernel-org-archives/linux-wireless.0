Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3993 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930Ab1HAMwm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2011 08:52:42 -0400
Message-ID: <4E36A18E.9060602@broadcom.com> (sfid-20110801_145245_508577_59EA9503)
Date: Mon, 1 Aug 2011 14:52:30 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <error27@gmail.com>
cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 18/35] staging: brcm80211: use mutex instead of
 semaphore in dhd_linux.c
References: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
 <1310678971-28952-19-git-send-email-frankyl@broadcom.com>
 <20110801115430.GH5575@shale.localdomain>
In-Reply-To: <20110801115430.GH5575@shale.localdomain>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/01/2011 01:54 PM, Dan Carpenter wrote:
> On Thu, Jul 14, 2011 at 02:29:14PM -0700, Franky Lin wrote:
>> From: Arend van Spriel<arend@broadcom.com>
>>
>> The semaphore proto_sem has been replaced with mutex proto_block
>> which lock certain code paths for one thread.
>>
> This one doesn't apply any more after the 3.1 merge window.
>
> It was modified in 1380516599 "Merge branch 'staging-next' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6"
>
> regards,
> dan carpenter

Hi Dan,

Thanks for the heads up. We sent three patch series that have not been 
taken into staging-next  due to the merge window. I tried looking for 
the commit id you mention (if it is one), but no luck in any common repo 
on git.kernel.org. Also I don't see a 3.1-rc1 tag yet.

I suspect we have to resend all three patch series once 3.1-rc1 is ready 
and available in Greg's staging repo. At least the patches have been on 
the mailing list long enough for people to provide us with comments. I 
already saw some of our source files mentioned in the merge of 
staging-next branch by Linus so I already had my suspicions regarding 
the patch series.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


