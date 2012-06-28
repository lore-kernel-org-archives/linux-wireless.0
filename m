Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:53358 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751152Ab2F1Fwo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 01:52:44 -0400
Received: by lbjn8 with SMTP id n8so3087510lbj.0
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 22:52:41 -0700 (PDT)
Message-ID: <1340862758.1631.638.camel@cumari.coelho.fi> (sfid-20120628_075249_261404_4F7E44D2)
Subject: Re: [PATCH 0/8] wlcore/wl12xx/wl18xx: patches of the day
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com
Date: Thu, 28 Jun 2012 08:52:38 +0300
In-Reply-To: <1340811362-30441-1-git-send-email-coelho@ti.com>
References: <1340811362-30441-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-27 at 18:35 +0300, Luciano Coelho wrote:
> Hi,
> 
> A few more patches for wlcore and friends.  Some improvements and bug
> fixes.  The most significant improvement is that now in wl12xx we
> allow sched scan while connected and allow normal scans while sched
> scanning.  The wl18xx firmware doesn't support this yet.
> 
> After this series, a newer firmware version is required.  We call it
> fw-5 for wl127x and wl128x now.
> 
> Cheers,
> Luca.
> 
> 
> Arik Nemtsov (5):
>   wlcore/wl12xx/wl18xx: check min FW version
>   wlcore: don't stop tx queue via watermark if already stopped
>   wlcore: remove recover cmd from testmode
>   wlcore: avoid debug prints during intended FW recovery
>   wlcore: always clear recovery flag during recovery_work
> 
> Luciano Coelho (1):
>   wl12xx/wlcore: increase FW filename version
> 
> Victor Goldenshtein (1):
>   wlcore: enable sched scan while connected
> 
> Yoni Divinsky (1):
>   wlcore: add probe request templates for sched and one-shot scans

Applied this series and pushed.

--
Luca.

