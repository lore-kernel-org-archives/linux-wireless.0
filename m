Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:41585 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757408Ab1F0IrV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 04:47:21 -0400
Received: by mail-bw0-f44.google.com with SMTP id 17so2054079bwb.17
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2011 01:47:19 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: fix erroneous commit (cb5ae0)
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1306236788-2921-1-git-send-email-eliad@wizery.com>
References: <1306236788-2921-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Jun 2011 11:42:00 +0300
Message-ID: <1309164120.30221.4.camel@cumari> (sfid-20110627_105907_228553_D8B0B616)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-05-24 at 14:33 +0300, Eliad Peller wrote: 
> Due to rebase error, the patch for commit cb5ae0 ("wl12xx: configure
> rates when working in ibss mode") was wrong - a blob was added
> into the wrong function. fix it.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied, thanks!

-- 
Cheers,
Luca.

