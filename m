Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:57062 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754933Ab1JKT0d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 15:26:33 -0400
Received: by mail-bw0-f44.google.com with SMTP id q10so11321993bka.31
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 12:26:25 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: handle injected packets
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1318333945-27839-1-git-send-email-eliad@wizery.com>
References: <1318333945-27839-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 22:26:16 +0300
Message-ID: <1318361176.9690.545.camel@cumari> (sfid-20111011_212636_809316_1A6B561A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-10-11 at 13:52 +0200, Eliad Peller wrote: 
> Injected packets are sent with no vif, causing the wl12xx
> to NULL-dereference in multiple places.
> 
> Furthermore, injected packets are currently not sent at all,
> as system_hlid doesn't belong to any specific role, so
> wl1271_skb_dequeue() never return its packets.
> 
> Handle both these problems.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied and added my:

Reported-by: Luciano Coelho <coelho@ti.com>

As agreed on IRC. ;)

-- 
Cheers,
Luca.

