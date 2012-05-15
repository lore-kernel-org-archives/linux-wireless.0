Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:45536 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932729Ab2EONkf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 09:40:35 -0400
Received: by lbgc1 with SMTP id c1so4520443lbg.29
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 06:40:33 -0700 (PDT)
Message-ID: <1337089231.4189.47.camel@cumari.coelho.fi> (sfid-20120515_154040_859705_D797DDB1)
Subject: Re: [PATCH 1/3] wlcore: flush tx on CHANGE_CHANNEL
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>
Date: Tue, 15 May 2012 16:40:31 +0300
In-Reply-To: <1337089126-11570-1-git-send-email-arik@wizery.com>
References: <1337089126-11570-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-05-15 at 16:38 +0300, Arik Nemtsov wrote:
> From: Eliad Peller <eliad@wizery.com>
> 
> On CHANGE_CHANNEL indication, we should flush all the
> queued tx frames, so they will be sent on the correct
> (current) channel.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

If this patch is From: Eliad, you need his s-o-b tag here too (assuming
he wants to sign it, of course ;).

-- 
Cheers,
Luca.

