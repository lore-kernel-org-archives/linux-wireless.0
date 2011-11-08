Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:49083 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932538Ab1KHOOB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 09:14:01 -0500
Received: by mail-bw0-f54.google.com with SMTP id zs8so797016bkb.27
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 06:13:59 -0800 (PST)
Subject: Re: [PATCH 0/3] wl12xx: improve firmware transfer efficiency
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1320302683-23403-1-git-send-email-coelho@ti.com>
References: <1320302683-23403-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 16:13:56 +0200
Message-ID: <1320761636.19479.16.camel@cumari> (sfid-20111108_151415_760446_351C8784)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-11-03 at 08:44 +0200, Luciano Coelho wrote: 
> Hello,
> 
> These patches increase the FW upload efficiency by using multiple SDIO
> blocks in a single write.  After a lot of measurements, studies and
> discussions, I came to the conclusion that 16K chunks is the optimal
> size to use.  This reduces the upload time by a factor of 0.43 on
> wl127x and by a factor of 0.17 on wl128x.  In absolute numbers this
> means 75ms and 179ms respectively.
> 
> The first patch changes the semantics and name of the blocksize
> alignment quirk to negative, to simplify the code in the next two
> patches.

Applied this series.

-- 
Cheers,
Luca.

