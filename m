Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:41217 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932474Ab1KHONv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 09:13:51 -0500
Received: by mail-bw0-f51.google.com with SMTP id t8so437795bka.10
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 06:13:49 -0800 (PST)
Subject: Re: [PATCH v2] wl12xx: clear wl->vif on remove_interface
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1320153170-5301-1-git-send-email-eliad@wizery.com>
References: <1320153170-5301-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 16:13:46 +0200
Message-ID: <1320761626.19479.15.camel@cumari> (sfid-20111108_151358_338526_21E1AE2D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-01 at 15:12 +0200, Eliad Peller wrote: 
> wl->vif should be cleared on remove_interface()
> (rather than on stop()) even when only a single
> vif is supported, because during vif mode change
> stop() might not get called (e.g. because of
> monitor interface existence)
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied.

-- 
Cheers,
Luca.

