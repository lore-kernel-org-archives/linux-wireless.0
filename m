Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2331 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753734Ab1HLTIH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 15:08:07 -0400
Message-ID: <4E457A0B.2090707@broadcom.com> (sfid-20110812_210811_590682_BF91BFCC)
Date: Fri, 12 Aug 2011 21:07:55 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Arend van Spriel" <arend@broadcom.com>
cc: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHv2 01/14] staging: brcm80211: use wait queues instead
 of semaphores in wl_cfg80211.c
References: <1313156101-16817-2-git-send-email-arend@broadcom.com>
 <1313175933-4323-1-git-send-email-arend@broadcom.com>
In-Reply-To: <1313175933-4323-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/12/2011 09:05 PM, Arend van Spriel wrote:
> In wl_cfg80211.c two semaphores were used to trigger a task to process
> an event. The wait queues are better suited for that purpose. This also
> removes checkpatch warning on sema_init() calls in this source file.
>
> Reviewed-by: Rafal Milecki<zajec5@gmail.com>
> Reviewed-by: Roland Vossen<rvossen@broadcom.com>
> Reviewed-by: Franky Lin<frankyl@broadcom.com>
> Signed-off-by: Arend van Spriel<arend@broadcom.com>
> ---
> Hi Greg,
>
> This patch replaces the original submitted [01/14] patch identified by:
>
> Message-ID:<1313156101-16817-2-git-send-email-arend@broadcom.com>
>
> Gr. AvS
> ---

I should have compiled it before sending v2. Please drop this one and 
stick with the original patch.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


