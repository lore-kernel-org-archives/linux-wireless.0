Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:42049 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757566Ab2DLMnx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 08:43:53 -0400
Received: by lagz14 with SMTP id z14so1497726lag.28
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2012 05:43:49 -0700 (PDT)
Message-ID: <1334234627.10398.39.camel@cumari> (sfid-20120412_144356_413195_E5D8BFE3)
Subject: Re: [PATCH 00/24] wl12xx/wl1251/wlcore: reorganize drivers part 2
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com
Date: Thu, 12 Apr 2012 15:43:47 +0300
In-Reply-To: <1334174020-18957-1-git-send-email-coelho@ti.com>
References: <1334174020-18957-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-04-11 at 22:53 +0300, Luciano Coelho wrote: 
> Hi again,
> 
> This is the second part of the reorganization we're doing.  After this set, we
> can publish the wl18xx driver, which I hope I'll send tomorrow.
> 
> The same work as before follows with this series.
> 
> Please review.

Applied and pushed this patchset to wl12xx.git/master.  I'll send a pull
request to John as soon as git.kernel.org syncs my push. :)

-- 
Cheers,
Luca.

