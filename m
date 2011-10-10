Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:49051 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753237Ab1JJS6U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 14:58:20 -0400
Received: by mail-ey0-f182.google.com with SMTP id 10so1598816eyd.41
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 11:58:17 -0700 (PDT)
Subject: Re: [PATCH 09/29] wl12xx: make event handling support multirole
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1318234397-21081-10-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
	 <1318234397-21081-10-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 21:58:14 +0300
Message-ID: <1318273094.9690.385.camel@cumari> (sfid-20111010_205824_856634_F4BF0F2B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-10-10 at 10:12 +0200, Eliad Peller wrote: 
> Some events don't indicate the role they are intended for.
> In these cases, iterate through all the relevant vifs,
> and pass the event to each one of them.
> 
> This is only a workaround. future fw releases should indicate
> the relevant role_id for such events.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Is this workaround really necessary? Are we going to have a firmware
that supports multi-role but does *not* pass the role_id for these
events?


-- 
Cheers,
Luca.

