Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:37297 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932146Ab1BWNzE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 08:55:04 -0500
Received: by mail-ww0-f54.google.com with SMTP id 18so160859wwi.35
        for <linux-wireless@vger.kernel.org>; Wed, 23 Feb 2011 05:55:03 -0800 (PST)
Subject: Re: [PATCH v2 0/8] wl12xx: AP-mode per link PSM
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1298413351-15462-1-git-send-email-arik@wizery.com>
References: <1298413351-15462-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 15:55:00 +0200
Message-ID: <1298469300.2104.25.camel@pimenta>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-02-23 at 00:22 +0200, Arik Nemtsov wrote:
> 
> This patchset introduces per-link PSM for AP-mode. The PS status of
> each
> link is updated from FW.
> The wl12xx concept of PSM is different from the mac80211 one - some
> data
> must remain in FW for a link in PSM since the TIM is updated
> automatically 

Applied the series.  Thanks, Arik!

-- 
Cheers,
Luca.

