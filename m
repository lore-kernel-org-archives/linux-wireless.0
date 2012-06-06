Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:46723 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757026Ab2FFRFg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 13:05:36 -0400
Received: by lahg1 with SMTP id g1so6067513lah.30
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 10:05:33 -0700 (PDT)
Message-ID: <1339002331.7078.34.camel@cumari.coelho.fi> (sfid-20120606_190540_234767_841E3E64)
Subject: Re: [PATCH] wl12xx: send beacon loss events to userspace
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Jun 2012 20:05:31 +0300
In-Reply-To: <1337082797-25423-1-git-send-email-eliad@wizery.com>
References: <1337082797-25423-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-05-15 at 14:53 +0300, Eliad Peller wrote:
> Send beacon loss events to userspace, so it will be
> able to initiate roaming before disconnection
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied and pushed, thanks!

--
Luca.

