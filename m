Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:38981 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751011Ab1JKMwY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 08:52:24 -0400
Received: by mail-bw0-f49.google.com with SMTP id c12so128684bkb.22
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 05:52:23 -0700 (PDT)
Subject: Re: [PATCH 00/29] make the driver ready for multi-vif support
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1318234397-21081-1-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 15:52:19 +0300
Message-ID: <1318337539.9690.521.camel@cumari> (sfid-20111011_145229_753713_8C5A7B81)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-10-10 at 10:12 +0200, Eliad Peller wrote: 
> This patchset finishes adding multiple vif support to the
> wl12xx driver.
> 
> The driver still allows only a single vif, as the current
> fw only supports a single vif.
> 
> This patchset doesn't break compatibility with the current fw.

Applied, thanks! With the following small changes:

* used v2 of 08/29;
* used '(foo - bar) & 0xff' instead of '(foo - bar + 256) % 256'.


-- 
Cheers,
Luca.

