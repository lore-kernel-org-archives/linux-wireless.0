Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:38962 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755182Ab1DAJJh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 05:09:37 -0400
Received: by eyg5 with SMTP id 5so953148eyg.10
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 02:09:35 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: fix "JOIN while associated" commentary
From: Luciano Coelho <coelho@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1301505511-26582-1-git-send-email-ohad@wizery.com>
References: <1301505511-26582-1-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 12:10:12 +0300
Message-ID: <1301649012.1988.447.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-03-30 at 19:18 +0200, Ohad Ben-Cohen wrote:
> Issuing multiple JOIN commands to the wl12xx's firmware, while
> we're associated, might have undesired implications, so the driver
> prints a message when that happens, and warn developers who check
> out the source.
> 
> Update the commentary in order to consider the one valid scenario
> where this can happen: roaming.
> 
> Cautiously keep the message for now, until we either gain confidence
> there are no unintentional JOIN-while-associated events, or until
> we move to the new multi-role fw who solves this multiple-join issue
> for good.
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> ---

Applied, thanks Ohad!

-- 
Cheers,
Luca.

