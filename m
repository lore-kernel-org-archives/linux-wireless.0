Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:33448 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755160Ab1DAHuA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 03:50:00 -0400
Received: by wyb28 with SMTP id 28so3986785wyb.22
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 00:49:57 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: configure channel/band while FW is off
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1300781267-4047-1-git-send-email-arik@wizery.com>
References: <1300781267-4047-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 10:50:34 +0300
Message-ID: <1301644234.1988.411.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-22 at 10:07 +0200, Arik Nemtsov wrote:
> Initialize the channel and band from mac80211 conf even when the FW is
> not yet loaded. This mitigates a bug in AP-mode where the channel was
> never changed from its initial setting after FW boot and was therefore
> never configured to FW.
> 
> Reported-by: Alexander Boukaty <alexanderb@ti.com>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

Applied, thank you.

-- 
Cheers,
Luca.

