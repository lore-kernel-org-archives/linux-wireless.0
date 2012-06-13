Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:36206 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754218Ab2FMTEl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 15:04:41 -0400
Received: by lahc1 with SMTP id c1so927439lah.18
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2012 12:04:38 -0700 (PDT)
Message-ID: <1339614276.10534.64.camel@cumari.coelho.fi> (sfid-20120613_210443_881798_7663E9B9)
Subject: Re: [PATCH v2] wlcore: send EAPOLs with basic rate policy
From: Luciano Coelho <coelho@ti.com>
To: Eyal Shapira <eyal@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 13 Jun 2012 22:04:36 +0300
In-Reply-To: <1339493995-17944-1-git-send-email-eyal@wizery.com>
References: <1339493995-17944-1-git-send-email-eyal@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-12 at 12:39 +0300, Eyal Shapira wrote:
> EAPOLs are sent at high rates as they are considered
> data packets. Some APs like Motorola Symbol AP7131 and AP650
> don't respond well to these rates and don't respond with
> EAPOL 3/4 consistently. When sending EAPOL 2/4 at 54Mbps
> we've seen approx 30% success rate in getting EAPOL 3/4 response
> while using 11Mbps we got 100% success.
> To increase the chances of successful 4-Way handshake with
> such APs, send EAPOLs with basic rate policy in order to avoid
> high rates.
> 
> Signed-off-by: Eyal Shapira <eyal@wizery.com>
> ---
> v2: added info about the APs and problem (Thanks Johannes!)
> Aside from that I'll send a separate patch for mac80211 so non HW rate
> control drivers will do the same.

Applied, thanks!

--
Luca.

