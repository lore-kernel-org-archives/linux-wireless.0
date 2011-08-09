Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:56842 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750722Ab1HIT3L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 15:29:11 -0400
Received: by mail-ey0-f172.google.com with SMTP id 4so516679eye.17
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 12:29:03 -0700 (PDT)
Subject: Re: [PATCH 07/40] wl12xx: wl12xx-fw-3 - update acx commands
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312881233-9366-8-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	 <1312881233-9366-8-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 22:29:01 +0300
Message-ID: <1312918141.2407.239.camel@cumari> (sfid-20110809_212916_164368_D7EC8329)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote: 
> Update the acx commands according to the new fw api.
> 
> The main change in most of the ACXs is the addition
> of a new role_id/link_id field, which is required
> for multi-role operation.
> 
> Currently, we don't really support multi-role, as
> most of our data (inside wl) is global.
> As the current fw doesn't support concurrent roles
> yet, keep it this way and add wl->role_id and
> wl->sta_hlid to save the active role/link.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Same thing here as with the previous patch.  Can you use wl12xx instead
of wl1271 for the new (or renamed or re-argumented) functions and
structs?

Otherwise I don't have any other comments to this patch.  There's
something I want to discuss with you about the role_id stuff, but I
think it's easier to do over IRC. ;)


-- 
Cheers,
Luca.

