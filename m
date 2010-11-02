Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:63161 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab0KBKMJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 06:12:09 -0400
Subject: Re: [PATCH 1/2] wl1271: handle HW watchdog interrupt
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1288181398-2358-1-git-send-email-eliad@wizery.com>
References: <1288181398-2358-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Nov 2010 12:11:57 +0200
Message-ID: <1288692717.24531.2.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-27 at 14:09 +0200, ext Eliad Peller wrote:
> unmask the WL1271_ACX_INTR_WATCHDOG interrupt.
> when getting it - enqueue a recovery work and bail out.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied and fixed a couple of checkpatch "line over 80 characters"
warnings.

Please remember to *always* run checkpatch and fix any eventual
warnings/errors before submitting.


-- 
Cheers,
Luca.

