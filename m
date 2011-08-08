Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3805 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab1HHMq4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 08:46:56 -0400
Message-ID: <4E3FDAB4.7000200@broadcom.com> (sfid-20110808_144700_349464_7DE6B22E)
Date: Mon, 8 Aug 2011 14:46:44 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "gregkh@suse.de" <gregkh@suse.de>
cc: "Dan Carpenter" <error27@gmail.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
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

Hi Greg,

Not sure what your plan is with our pending patches, but given the 
feedback from Dan could you drop all of them so I can resubmit them.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


