Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:53675 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752240Ab1IWLoZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 07:44:25 -0400
Received: by mail-bw0-f51.google.com with SMTP id zu17so4584996bkb.24
        for <linux-wireless@vger.kernel.org>; Fri, 23 Sep 2011 04:44:24 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: send all pending packets on channel change
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1316080801-20803-1-git-send-email-eliad@wizery.com>
References: <1316080801-20803-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Sep 2011 14:44:21 +0300
Message-ID: <1316778261.2157.732.camel@cumari> (sfid-20110923_134428_490594_98525C5A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-15 at 13:00 +0300, Eliad Peller wrote: 
> There is a race condition between wl1271_tx_work() and the
> channel switch, so make sure all the pending packets are
> being sent before switching channel.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied, thank you.

-- 
Cheers,
Luca.

