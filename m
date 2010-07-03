Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:10920 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855Ab0GCOEh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Jul 2010 10:04:37 -0400
Subject: Re: ath: Fix uninitialized variable warnings [v2]
From: Pavel Roskin <proski@gnu.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@atheros.com,
	linville@tuxdriver.com
In-Reply-To: <20100701160048.23795.39782.sendpatchset@prarit.bos.redhat.com>
References: <20100701160048.23795.39782.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain
Date: Sat, 03 Jul 2010 10:04:32 -0400
Message-Id: <1278165872.6710.1.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-07-01 at 12:09 -0400, Prarit Bhargava wrote:
> Fix 'make CONFIG_DEBUG_SECTION_MISMATCH=y' warning:

I don't think the warnings you are fixing have anything to do with
CONFIG_DEBUG_SECTION_MISMATCH.

> drivers/net/wireless/mwl8k.c: In function 'mwl8k_bss_info_changed_sta':
> drivers/net/wireless/mwl8k.c:3404: warning: 'ap_legacy_rates' may be used uninitialized in this function

The patch doesn't appear to touch mwl8k.c at all.

Please fix the description.

-- 
Regards,
Pavel Roskin
