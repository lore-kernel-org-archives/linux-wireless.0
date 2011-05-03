Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:43420 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668Ab1ECMS6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 08:18:58 -0400
Date: Tue, 3 May 2011 05:15:22 -0700
From: Greg KH <gregkh@suse.de>
To: sukeshs@broadcom.com
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] brcm80211: Fix for suspend/resume bug
Message-ID: <20110503121522.GB22674@suse.de> (sfid-20110503_141901_313615_4F2A2974)
References: <1304406057-8722-1-git-send-email-sukeshs@broadcom.com>
 <1304406057-8722-3-git-send-email-sukeshs@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1304406057-8722-3-git-send-email-sukeshs@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 03, 2011 at 12:00:57AM -0700, sukeshs@broadcom.com wrote:
>  #if defined(CONFIG_PM_SLEEP)
>  
> +extern volatile bool dhd_mmc_suspend;

This does not do what you think it does.

