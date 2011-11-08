Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:52425 "HELO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751840Ab1KHOT0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 09:19:26 -0500
Received: by mail-bw0-f49.google.com with SMTP id t2so726773bka.22
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 06:19:23 -0800 (PST)
Subject: Re: [PATCH v2 1/2] wl12xx: set scan probe requests rate according
 to the no_cck flag
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1320132232-12283-1-git-send-email-eliad@wizery.com>
References: <1320132232-12283-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 16:19:20 +0200
Message-ID: <1320761960.19479.19.camel@cumari> (sfid-20111108_151930_558117_6B9CADFF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-01 at 09:23 +0200, Eliad Peller wrote: 
> From: Guy Eilam <guy@wizery.com>
> 
> Set the TX rate of probe requests during scanning according to the
> no_cck flag in the scan request struct.
> 
> Signed-off-by: Guy Eilam <guy@wizery.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied both patches, thanks!

-- 
Cheers,
Luca.

