Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:60972 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750695Ab1HINhf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 09:37:35 -0400
Received: by mail-ew0-f44.google.com with SMTP id 19so1729832ewy.3
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 06:37:19 -0700 (PDT)
Subject: Re: [PATCH 06/40] wl12xx: wl12xx-fw-3 - Update fw status struct
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312881233-9366-7-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	 <1312881233-9366-7-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 16:37:16 +0300
Message-ID: <1312897036.2407.186.camel@cumari> (sfid-20110809_153737_883461_A721A5B7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote: 
> Update the fw status struct according to the new fw api.
> All the roles use the same struct now.
> 
> The memory accounting was changed a bit according to
> the struct changes.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

I don't think we need the "wl12xx-fw-3 - " in the title of any of these
patches...

-- 
Cheers,
Luca.

