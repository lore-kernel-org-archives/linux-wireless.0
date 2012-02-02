Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:60812 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753140Ab2BBIJy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 03:09:54 -0500
Received: by lagz14 with SMTP id z14so2049889lag.27
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 00:09:51 -0800 (PST)
Subject: Re: [PATCH v2 4/7] wl12xx: add forced_ps debugfs file
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1328168696.3626.247.camel@cumari>
References: <1328021048-8944-1-git-send-email-eliad@wizery.com>
	 <1328021048-8944-5-git-send-email-eliad@wizery.com>
	 <1328168696.3626.247.camel@cumari>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Feb 2012 10:09:48 +0200
Message-ID: <1328170188.3626.256.camel@cumari> (sfid-20120202_091019_965002_BF9D73F2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-02-02 at 09:44 +0200, Luciano Coelho wrote: 
> On Tue, 2012-01-31 at 16:44 +0200, Eliad Peller wrote: 
> > From: Eyal Shapira <eyal@wizery.com>
> > 
> > Added control over forced_ps option through debugfs.
> > This can be either 1 or 0.
> > 
> > Signed-off-by: Eyal Shapira <eyal@wizery.com>
> > Signed-off-by: Eliad Peller <eliad@wizery.com>
> > ---
> 
> Ah, now I see it. :)
> 
> This should be squashed with the previous one.

Changed my mind, no need to squash.


-- 
Cheers,
Luca.

