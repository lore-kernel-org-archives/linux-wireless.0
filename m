Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34707 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbbHRGCS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 02:02:18 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: rtlwifi: rtl8192cu: Remove pci check routine
 inrtl92c_enable_interrupt.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1428652199-28713-1-git-send-email-ap420073@gmail.com>
To: Taehee Yoo <ap420073@gmail.com>
Cc: Larry.Finger@lwfinger.net, ap420073@gmail.com,
	linux-wireless@vger.kernel.org
Message-Id: <20150818060217.77A18140366@smtp.codeaurora.org> (sfid-20150818_080220_935697_2697623E)
Date: Tue, 18 Aug 2015 06:02:17 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I change three things about below.
> 
> 1. remove pci interface check routine in rtl92c_enable_interrupt
> because rtl8192cu chipset is always usb interface.
> 
> 2. rename rtl92c_xxx_interrupt to rtl92cu_xxx_interrupt.
> rtl92c_xxx_interrupt functions can only be handled rtl8192cu chipset.
> 
> 3. remove rtl92c_init_interrupt wrapper function
> because rtl92cu_enable_interrupt does not need to have the wrapper function anymore.
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

This failed to apply:

Applying: rtlwifi: rtl8192cu: Remove pci check routine in rtl92c_enable_interrupt.
Using index info to reconstruct a base tree...
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/rtlwifi/rtl8192cu/mac.h
CONFLICT (content): Merge conflict in drivers/net/wireless/rtlwifi/rtl8192cu/mac.h
Auto-merging drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
Auto-merging drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
Failed to merge in the changes.
Patch failed at 0001 rtlwifi: rtl8192cu: Remove pci check routine in rtl92c_enable_interrupt.

Kalle
