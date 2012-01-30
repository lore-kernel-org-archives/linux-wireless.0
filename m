Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:47926 "HELO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752232Ab2A3Trt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 14:47:49 -0500
Received: by mail-lpp01m010-f44.google.com with SMTP id l5so2337557lah.3
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 11:47:48 -0800 (PST)
Subject: Re: [PATCH 03/12] wl12xx: use dev_role_id for sched scan
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1327924857-1250-4-git-send-email-eliad@wizery.com>
References: <1327924857-1250-1-git-send-email-eliad@wizery.com>
	 <1327924857-1250-4-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Jan 2012 21:47:43 +0200
Message-ID: <1327952863.3626.105.camel@cumari> (sfid-20120130_204751_568025_235D55ED)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-01-30 at 14:00 +0200, Eliad Peller wrote: 
> sched_scan is used only when the sta is
> not associated, and thus should use
> the dev role (instead of sta role)
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Can you squash this with 02/12?

-- 
Cheers,
Luca.

