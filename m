Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:33720 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932596AbXBSTtm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 14:49:42 -0500
Date: Mon, 19 Feb 2007 20:49:38 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] d80211: Allow drivers to configure default regulatory  domain
Message-ID: <20070219204938.29520759@griffin.suse.cz>
In-Reply-To: <200702180031.38710.flamingice@sourmilk.net>
References: <200702180031.38710.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 18 Feb 2007 00:31:33 -0500, Michael Wu wrote:
> This patch allows drivers to configure the default set of channels if the
> device reports its default regulatory domain.

How is a driver supposed to handle this? By walking through the channel
list and based on some value obtained from its EEPROM (or firmware or
whatever) set appropriate flags? That sounds like a need for duplicate
code in drivers. Shouldn't the stack accept a regdomain code (defined
as an enum of integers or so) instead?

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
