Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:57833 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbXKOR75 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 12:59:57 -0500
Received: by py-out-1112.google.com with SMTP id u77so3639350pyb
        for <linux-wireless@vger.kernel.org>; Thu, 15 Nov 2007 09:59:56 -0800 (PST)
Message-ID: <43e72e890711150959p12810b6auc39138fae9072eb8@mail.gmail.com> (sfid-20071115_180000_590027_AF5EDA17)
Date: Thu, 15 Nov 2007 12:59:56 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
Subject: Re: [PATCH 1/4] ath5k: Fix another faulty channel flag check
In-Reply-To: <20071114161139.GA6365@localhost.domain.invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071114161139.GA6365@localhost.domain.invalid>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 14, 2007 11:11 AM, Nick Kossifidis <mick@madwifi.org> wrote:
> *Fix another faulty channel flags check
>
> Don't check channel->val against CHANNEL_A/B/G flags because they have common flags set
> eg. doing AND between CHANNEL_A and CHANNEL_G always returns true because they have
> CHANNEL_OFDM, same goes for CHANNEL_B and CHANNEL_G that have CHANNEL_2GHZ in common.
>
> Instead check against CHANNEL_CCK/OFDM/2GHZ/5GHZ...
>
> Changes-licensed-under: ISC
> Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

Acked-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>

  Luis
