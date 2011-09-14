Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:42264 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755168Ab1INJUF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 05:20:05 -0400
Received: by bkbzt4 with SMTP id zt4so1559356bkb.5
        for <linux-wireless@vger.kernel.org>; Wed, 14 Sep 2011 02:20:02 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: use kstrtoul_from_user
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1314791413-32358-1-git-send-email-eliad@wizery.com>
References: <1314791413-32358-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Sep 2011 12:20:00 +0300
Message-ID: <1315992000.2498.77.camel@cumari> (sfid-20110914_112009_365205_0B638014)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-31 at 14:50 +0300, Eliad Peller wrote: 
> simplify code by calling kstrtoul_from_user() (instead of
> copy_from_user() + kstrtoul())
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied, thanks!

-- 
Cheers,
Luca.

