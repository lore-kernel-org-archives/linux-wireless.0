Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34040 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbYIZQ1T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 12:27:19 -0400
Date: Fri, 26 Sep 2008 12:26:44 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Anna Neal <anna@cozybit.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Subject: Re: [PATCH] libertas: Improvements on automatic tx power control
	via SIOCSIWTXPOW.
Message-ID: <20080926162643.GB3483@tuxdriver.com> (sfid-20080926_182722_945258_C8C87536)
References: <48dc2080.14be600a.433d.fffffde3@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48dc2080.14be600a.433d.fffffde3@mx.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 25, 2008 at 04:19:31PM -0700, Anna Neal wrote:
> iwconfig txpower can now be used to set tx power to fixed or auto. If set to
> auto the default firmware settings are used.
> 
> The command CMD_802_11_PA_CFG is only sent to older firmware, as Dan Williams
> noted the command was no longer supported in firmware V9+.
> 
> Signed-off-by: Anna Neal <anna@cozybit.com>
> Signed-off-by: Javier Cardona <javier@cozybit.com>

I had already committed an earlier version.  I believe I have
incorporated all the changes in "libertas: Improvements on automatic tx
power control via SIOCSIWTXPOW (fixups)" -- please feel free to verify.

Thanks,

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
