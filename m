Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:33430 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751176Ab1CUNgJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 09:36:09 -0400
Received: by mail-ew0-f52.google.com with SMTP id 28so1794476ewy.39
        for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 06:36:08 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: update bet_max_consecutive
From: Luciano Coelho <coelho@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1300121590-27998-1-git-send-email-ohad@wizery.com>
References: <1300121590-27998-1-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Mar 2011 15:35:30 +0200
Message-ID: <1300714530.2593.205.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-03-14 at 18:53 +0200, Ohad Ben-Cohen wrote:
> Allow early termination of 50 consecutive beacons.
> 
> This value is the recommended one by the 12xx's system/RF team,
> and tests show that power consumption is improved as expected.
> 
> Reported-by: Ruthy Zaphir <ruthyz@ti.com>
> Tested-by: Danil Shalumov <danils@ti.com>
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> ---

Applied, thank you!

-- 
Cheers,
Luca.

