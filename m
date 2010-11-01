Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:36017 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757816Ab0KANXJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 09:23:09 -0400
Subject: Re: [PATCH 1/2] wl1271: handle HW watchdog interrupt
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1288181398-2358-1-git-send-email-eliad@wizery.com>
References: <1288181398-2358-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Nov 2010 15:22:50 +0200
Message-ID: <1288617770.20937.8.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Eliad,

On Wed, 2010-10-27 at 14:09 +0200, ext Eliad Peller wrote:
> unmask the WL1271_ACX_INTR_WATCHDOG interrupt.
> when getting it - enqueue a recovery work and bail out.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

This looks good.  Just to clarify, the hardware is going to send this
event when something goes wrong? What kind of situation triggers this
event?


-- 
Cheers,
Luca.

