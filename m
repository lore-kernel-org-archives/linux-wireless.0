Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:43371 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab3EGOZb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 10:25:31 -0400
Message-ID: <1367936649.32148.96.camel@cumari.coelho.fi> (sfid-20130507_162547_111940_52989A24)
Subject: Re: [PATCH 2/3] wlcore: configure rates in multiple cases
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 07 May 2013 17:24:09 +0300
In-Reply-To: <1367930469-29826-2-git-send-email-eliad@wizery.com>
References: <1367930469-29826-1-git-send-email-eliad@wizery.com>
	 <1367930469-29826-2-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-05-07 at 15:41 +0300, Eliad Peller wrote:
> The current code configures the peer caps only on BSS_CHANGED_HT
> notification. However, we have to configure the peer caps
> (and rates) even when HT is not enabled. Otherwise, the fw
> continues working with low rates.
> 
> Configure the peer caps when sta_exists is true (i.e. when
> we extracted the sta rates, e.g. on association).
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied and pushed 2/3 and 3/3.  Thanks, Eliad!

--
Luca.

