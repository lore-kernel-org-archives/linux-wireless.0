Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:52019 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753019Ab1HJLyL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 07:54:11 -0400
Received: by mail-bw0-f42.google.com with SMTP id 19so312623bkd.29
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 04:54:09 -0700 (PDT)
Subject: Re: [PATCH 10/40] wl12xx: add device role commands
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312881233-9366-11-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	 <1312881233-9366-11-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 14:54:06 +0300
Message-ID: <1312977246.2407.561.camel@cumari> (sfid-20110810_135414_376035_27362C88)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote: 
> The device role is a special role used for rx and tx frames
> prior to association (as the STA role can get packets only
> from its associated bssid)
> 
> Since this role is required for the sta association process,
> we enable it when a new sta interface is created.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

This patch looks fine, except for the relevant s/wl1271/wl12xx/.  And it
would also be good if you could add some comments in the code about what
this device role is about.  Something similar to the commit description
here would be good.

-- 
Cheers,
Luca.

