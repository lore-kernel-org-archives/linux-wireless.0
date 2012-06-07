Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:48918 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756266Ab2FGPft (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 11:35:49 -0400
Received: by lagw12 with SMTP id w12so540413lag.24
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 08:35:47 -0700 (PDT)
Message-ID: <1339083345.7078.100.camel@cumari.coelho.fi> (sfid-20120607_173553_833982_86750046)
Subject: Re: [PATCH v2] wl12xx: Add support for an external 26 MHz crystal
 source
From: Luciano Coelho <coelho@ti.com>
To: Grant Erickson <marathon96@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 07 Jun 2012 18:35:45 +0300
In-Reply-To: <1338567541-25585-1-git-send-email-marathon96@gmail.com>
References: <1338567541-25585-1-git-send-email-marathon96@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-01 at 09:19 -0700, Grant Erickson wrote:
> Add support for an external 26 MHz crystal source.
> 
> Signed-off-by: Grant Erickson <marathon96@gmail.com>
> ---
>   v1 Initial submission.
>   v2 Add a body description to the commit.

Applied and pushed, thanks Grant!

I have only changed the wl->ref_clock to priv->ref_clock that is used
now.

--
Luca.

