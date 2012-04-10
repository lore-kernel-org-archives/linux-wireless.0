Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:60940 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751514Ab2DJKUO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 06:20:14 -0400
Received: by lbbge1 with SMTP id ge1so3151041lbb.37
        for <linux-wireless@vger.kernel.org>; Tue, 10 Apr 2012 03:20:12 -0700 (PDT)
Message-ID: <1334053210.10398.1.camel@cumari> (sfid-20120410_122028_313364_498B368F)
Subject: Re: [PATCH] wl12xx: free ap keys only in ap mode
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 10 Apr 2012 13:20:10 +0300
In-Reply-To: <1332149575-22284-1-git-send-email-eliad@wizery.com>
References: <1332149575-22284-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-03-19 at 11:32 +0200, Eliad Peller wrote: 
> The ap keys should be freed only when removing
> ap role (otherwise, some arbitrary data might
> get freed).
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Pushed, thank you.

-- 
Cheers,
Luca.

