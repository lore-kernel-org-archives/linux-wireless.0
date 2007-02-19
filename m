Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:34732 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932655AbXBSU76 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 15:59:58 -0500
Date: Mon, 19 Feb 2007 21:59:56 +0100
From: Jiri Benc <jbenc@suse.cz>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] d80211: Allow drivers to configure default regulatory  domain
Message-ID: <20070219215956.6c73b36f@griffin.suse.cz>
In-Reply-To: <45DA0A7C.5010001@linux.intel.com>
References: <200702180031.38710.flamingice@sourmilk.net>
	<20070219204938.29520759@griffin.suse.cz>
	<45DA0A7C.5010001@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 19 Feb 2007 12:37:16 -0800, James Ketrenos wrote:
> Unfortunately it is vendor and device specific.  I think we can 
> generalize things to provide helper functions and macros such that each 
> driver does it roughly the same way, but the stack itself can't do it.

If the stack really cannot do it, yes, such helpers make sense.

> The hardware needs to tell the stack all the channels it supports and 
> the restrictions on those channels.  The stack can then further restrict 
> the set of channels based on the user input to a "standard" set of 
> countries.

Yes.

> "regdomains" are not static maps; they evolve over time as governments 
> change their regulations.  The channels and features supported by 
> hardware is static based on what the device was certified for.

Ok.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
