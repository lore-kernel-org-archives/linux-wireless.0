Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:34796 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757119Ab2BOKOO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 05:14:14 -0500
Received: by lamf4 with SMTP id f4so823824lam.28
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2012 02:14:11 -0800 (PST)
Message-ID: <1329300848.19569.38.camel@cumari> (sfid-20120215_111417_367513_80A95997)
Subject: Re: [PATCH 1/2] wl12xx: check bss_conf->assoc on CHANGED_BSSID
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 15 Feb 2012 12:14:08 +0200
In-Reply-To: <1327421923-25586-1-git-send-email-eliad@wizery.com>
References: <1327421923-25586-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-01-24 at 18:18 +0200, Eliad Peller wrote: 
> with the new auth/assoc redesign, we get CHANGED_BSSID
> indication before CHANGED_ASSOC indication, while our
> CHANGED_BSSID handling block assumes we are already
> associated.
> 
> Fix it by checking we are either in ibss mode, or
> already associated.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied the set, thanks!

-- 
Cheers,
Luca.

