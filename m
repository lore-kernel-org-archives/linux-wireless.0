Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:30577 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766Ab0GFQgE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jul 2010 12:36:04 -0400
Subject: Re: ath: Fix uninitialized variable warnings [v2]
From: Pavel Roskin <proski@gnu.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@atheros.com,
	linville@tuxdriver.com
In-Reply-To: <4C331BB9.5010005@redhat.com>
References: <20100701160048.23795.39782.sendpatchset@prarit.bos.redhat.com>
	 <1278165872.6710.1.camel@mj>  <4C331BB9.5010005@redhat.com>
Content-Type: text/plain
Date: Tue, 06 Jul 2010 12:35:58 -0400
Message-Id: <1278434158.20061.1.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-07-06 at 08:04 -0400, Prarit Bhargava wrote:

> New patch with updated description.

Your patch doesn't apply anymore.

> Fix 'make CONFIG_DEBUG_SECTION_MISMATCH=y' warning:

I tried to reproduce the warning, but could not.  I guess my gcc is old
(4.4.1) or you used more options that enable warnings.

> Pavel pointed out that tMinCalPower or pMinCalPower isn't used anywhere, so
> the simplest way to fix these warnings is to get rid of the code.

That alone is the best reason.  I'll resend the updated patch.

-- 
Regards,
Pavel Roskin
