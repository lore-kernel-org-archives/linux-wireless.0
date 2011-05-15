Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3637 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab1EOT7V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 May 2011 15:59:21 -0400
Message-ID: <4DD03089.9000900@broadcom.com> (sfid-20110515_215924_184271_BB3C8C5F)
Date: Sun, 15 May 2011 21:59:05 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Clemens Noss" <cnoss@gmx.de>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Brett Rudley" <brudley@broadcom.com>
Subject: Re: [PATCH] staging: brcm80211: fix cast to pointer from
 integer
References: <1305479060-22755-1-git-send-email-cnoss@gmx.de>
In-Reply-To: <1305479060-22755-1-git-send-email-cnoss@gmx.de>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/15/2011 07:04 PM, Clemens Noss wrote:
> bcm_pktq_flush and related functions only ever get 0 or a pointer for
> arg, so make it a pointer.
>
> This might fix a crash on 64bit.
>
> Signed-off-by: Clemens Noss<cnoss@gmx.de>
> ---
Hi Clemens,

Please note that patches on our driver should be sent to Greg KH 
<gregkh@suse.de> and Cc <devel@linuxdriverproject.org> as we are still 
in staging tree.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


