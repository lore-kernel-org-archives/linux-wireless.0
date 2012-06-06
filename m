Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:56306 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754844Ab2FFI1F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 04:27:05 -0400
Received: by lags15 with SMTP id s15so4459563lag.6
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 01:27:01 -0700 (PDT)
Message-ID: <1338970761.7078.4.camel@cumari.coelho.fi> (sfid-20120606_102712_393629_446798A6)
Subject: Re: [PATCH v2 1/3] wlcore: flush tx on CHANGE_CHANNEL
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>
Date: Wed, 06 Jun 2012 11:19:21 +0300
In-Reply-To: <1337089618-12450-1-git-send-email-arik@wizery.com>
References: <1337089618-12450-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-05-15 at 16:46 +0300, Arik Nemtsov wrote:
> From: Eliad Peller <eliad@wizery.com>
> 
> On CHANGE_CHANNEL indication, we should flush all the
> queued tx frames, so they will be sent on the correct
> (current) channel.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---
> v1->2: added SOB tag by eliad

Applied and pushed this set, thanks!

--
Luca.

