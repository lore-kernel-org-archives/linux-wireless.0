Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:46952 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993Ab0DVVis (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Apr 2010 17:38:48 -0400
Subject: Re: rc80211_minstrel.c:70 WARNING with 2.6.34-rc4
From: Pavel Roskin <proski@gnu.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Richard Zidlicky <rz@linux-m68k.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4BCC9A27.9000104@openwrt.org>
References: <20100418085653.GA7345@linux-m68k.org>
	 <1271694855.9026.51.camel@mj> <20100419174100.GA5312@linux-m68k.org>
	 <4BCC95CC.7030109@openwrt.org> <20100419175508.GB5312@linux-m68k.org>
	 <4BCC9A27.9000104@openwrt.org>
Content-Type: text/plain
Date: Thu, 22 Apr 2010 17:38:41 -0400
Message-Id: <1271972321.12589.2.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-04-19 at 20:00 +0200, Felix Fietkau wrote:

> > can that happen when both ends are configured to a fixed rate of 11M?
> No idea. I've never used fixed-rate. I guess it could, if it uses 11M
> for communicating with a peer that it for some reason did not enable
> this rate for.

I think if there is a legitimate condition when it can happen, we should
not be using WARN_ON.

-- 
Regards,
Pavel Roskin
