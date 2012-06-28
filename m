Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:48484 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751152Ab2F1FxB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 01:53:01 -0400
Received: by lbok6 with SMTP id k6so3460154lbo.18
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 22:52:59 -0700 (PDT)
Message-ID: <1340862775.1631.639.camel@cumari.coelho.fi> (sfid-20120628_075304_948255_2EAE4D09)
Subject: Re: [PATCH] wlcore: implement .flush callback
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, Eliad Peller <eliad@wizery.com>
Date: Thu, 28 Jun 2012 08:52:55 +0300
In-Reply-To: <1340813387-18407-1-git-send-email-coelho@ti.com>
References: <1340813387-18407-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-27 at 19:09 +0300, Luciano Coelho wrote:
> From: Eliad Peller <eliad@wizery.com>
> 
> implement the .flush() callback by simply calling wl1271_tx_flush().
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

Applied and pushed.

--
Luca.

