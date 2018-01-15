Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36594 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753074AbeAOMTX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 07:19:23 -0500
Message-ID: <1516018760.410.18.camel@sipsolutions.net> (sfid-20180115_131927_426088_A866472F)
Subject: Re: [PATCH v3 5/5] mac80211_hwsim: add hwsim_tx_rate_flags to
 netlink attributes
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 15 Jan 2018 13:19:20 +0100
In-Reply-To: <6071f4de-9547-411d-a641-5a409aa747a9@MAIL2.uni-rostock.de>
References: <20180110164255.2763-1-benjamin.beichler@uni-rostock.de>
         <6071f4de-9547-411d-a641-5a409aa747a9@MAIL2.uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-01-10 at 17:42 +0100, Benjamin Beichler wrote:
> For correct interpretation of a tx rate, the corresponding rate flags are
> needed (e.g. whether a HT-MCS rate or a legacy rate) and moreover for more
> correct simulation the other infos of the flags are important (like
> short-GI). Keeping compatibility, the flags are not integrated into the
> existing hwsim_tx_rate, but transmitted as an additional netlink attribute.

Also applied.

johannes
