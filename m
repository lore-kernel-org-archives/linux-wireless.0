Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:59960 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab1HAL4c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2011 07:56:32 -0400
Received: by pzk37 with SMTP id 37so11372511pzk.1
        for <linux-wireless@vger.kernel.org>; Mon, 01 Aug 2011 04:56:32 -0700 (PDT)
Date: Mon, 1 Aug 2011 14:54:30 +0300
From: Dan Carpenter <error27@gmail.com>
To: Franky Lin <frankyl@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 18/35] staging: brcm80211: use mutex instead of semaphore
 in dhd_linux.c
Message-ID: <20110801115430.GH5575@shale.localdomain> (sfid-20110801_135646_971190_97D1538C)
References: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
 <1310678971-28952-19-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1310678971-28952-19-git-send-email-frankyl@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 14, 2011 at 02:29:14PM -0700, Franky Lin wrote:
> From: Arend van Spriel <arend@broadcom.com>
> 
> The semaphore proto_sem has been replaced with mutex proto_block
> which lock certain code paths for one thread.
> 

This one doesn't apply any more after the 3.1 merge window.

It was modified in 1380516599 "Merge branch 'staging-next' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6"

regards,
dan carpenter
