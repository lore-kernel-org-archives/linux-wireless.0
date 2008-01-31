Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.182]:29911 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757930AbYAaPHb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2008 10:07:31 -0500
Received: by el-out-1112.google.com with SMTP id v27so239311ele.23
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jan 2008 07:07:29 -0800 (PST)
Message-ID: <43e72e890801310707u8e29468h3de981c0e3c72c52@mail.gmail.com> (sfid-20080131_150746_130331_1B4C4FBC)
Date: Thu, 31 Jan 2008 10:07:28 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com, johannes@sipsolutions.net
Subject: Re: [PATCH] ath5k: Port to new bitrate/channel API
In-Reply-To: <20080130183824.GA7676@makis.domain.invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080130183824.GA7676@makis.domain.invalid>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 30, 2008 1:38 PM, Nick Kossifidis <mick@madwifi.org> wrote:
> Tested on 5211, 5213+5112, 5213A+2112A and it wors fine.
>
> Also i figured out a way to process rate vallue found on status descriptors,
> it's still buggy but we are getting closer (i think it improved stability a little).
>
> Changes-licensed-under: 3-clause-BSD
> Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

My approach was little more extreme removing ath5k_rate struct and led
stuff completely but well, its not done. Also we definitely still do
dependent on mode stuff a lot and the whole capaibilty stuff is used
inconsistantly. If anything I can base patches on this work.

Nick, just please review the license and files you've changed. Other
than that it looks OK.

Acked-by:  Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>

  Luis
