Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:54254 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753273Ab1HJPUe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 11:20:34 -0400
Received: by bkd1 with SMTP id 1so440688bkd.12
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 08:20:30 -0700 (PDT)
Subject: Re: [PATCH 21/40] wl12xx: fix session counter
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312881233-9366-22-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	 <1312881233-9366-22-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 18:20:27 +0300
Message-ID: <1312989627.2407.703.camel@cumari> (sfid-20110810_172041_723296_0F4ADB52)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote: 
> From: Arik Nemtsov <arik@wizery.com>
> 
> Increment the session counter on every join command.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Looks fine, but the commit log is misleading, because it's not done in
every join, but in every wl1271_cmd_role_start_sta() call (ie. it is
only used for STA).

-- 
Cheers,
Luca.

