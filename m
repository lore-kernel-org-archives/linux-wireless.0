Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:49052 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751801Ab2FXHiS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jun 2012 03:38:18 -0400
Received: by lbok6 with SMTP id k6so6540429lbo.32
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jun 2012 00:38:14 -0700 (PDT)
Message-ID: <1340523493.1631.420.camel@cumari.coelho.fi> (sfid-20120624_093821_665168_ED67FE16)
Subject: Re: [PATCH 00/18] wlcore: improvements in SDIO error handling
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, ido@wizery.com
Date: Sun, 24 Jun 2012 10:38:13 +0300
In-Reply-To: <1340433689-24320-1-git-send-email-coelho@ti.com>
References: <1340433689-24320-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-06-23 at 09:41 +0300, Luciano Coelho wrote:
> Hi,
> 
> This series with patches from Ido and Arik improve the driver's
> handling of SDIO errors.  Ido's series propagates the errors up for
> better handling and Arik's series ensures that suspend/resume don't
> get messed up when such errors occur.
> 
> There is also one patch by Arkady (welcome!) that allows the userspace
> to read/write to the chip's memory directly for firmware debugging
> purposes.
> 
> Please review.

Applied and push this series to wl12xx.git/master.

--
Luca.

