Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:53322 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758552Ab0LMRna (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 12:43:30 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 09:43:14 -0800
Date: Mon, 13 Dec 2010 09:43:21 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Dave Vasilevsky <dave@vasilevsky.ca>
CC: "Luis R. Rodriguez" <mcgrof@kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: compat-wireless-2.6: out of date b43 config option in config.mk
Message-ID: <20101213174321.GB637@tux>
References: <AANLkTin-JwhK_SRhSPrzWJM6fJ9p_rEWVeTLGKk1pyUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <AANLkTin-JwhK_SRhSPrzWJM6fJ9p_rEWVeTLGKk1pyUw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 10, 2010 at 07:46:16PM -0800, Dave Vasilevsky wrote:
> Hi Luis,
> 
> Thanks for your work on compat-wireless, you are officially awesome :)
>  I just noticed that recent changes in the b43 driver have renamed
> CONFIG_B43_NPHY to CONFIG_B43_PHY_N, but config.mk in
> compat-wireless-2.6 is still using the old config option name. Thought
> I should let you know.

CONFIG_B43_NPHY is still used, and we have CONFIG_B43_PHY_LP=y as well.
I don't see any CONFIG_B43_PHY_N on upstream.

  Luis
