Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:46652 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751747Ab1DTSAT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 14:00:19 -0400
Received: by mail-ey0-f172.google.com with SMTP id 13so463634eye.17
        for <linux-wireless@vger.kernel.org>; Wed, 20 Apr 2011 11:00:15 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: print actual rx packet size (without padding)
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1302016891-19091-1-git-send-email-eliad@wizery.com>
References: <1302016891-19091-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Apr 2011 21:02:41 +0300
Message-ID: <1303322561.1988.739.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-04-05 at 18:21 +0300, Eliad Peller wrote:
> When debugging, reduce the padding size from each rx packet, to
> get the actual packet size (so comparing it against a cap file
> will be easier)
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied.  Thanks!

-- 
Cheers,
Luca.

