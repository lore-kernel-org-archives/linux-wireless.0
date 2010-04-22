Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:50733 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab0DVWNM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Apr 2010 18:13:12 -0400
Received: by fg-out-1718.google.com with SMTP id 19so71837fgg.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 Apr 2010 15:13:09 -0700 (PDT)
Date: Fri, 23 Apr 2010 00:15:44 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Pavel Roskin <proski@gnu.org>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Subject: Re: rc80211_minstrel.c:70 WARNING with 2.6.34-rc4
Message-ID: <20100422221544.GA15879@linux-m68k.org>
References: <20100418085653.GA7345@linux-m68k.org> <1271694855.9026.51.camel@mj> <20100419174100.GA5312@linux-m68k.org> <4BCC95CC.7030109@openwrt.org> <20100419175508.GB5312@linux-m68k.org> <4BCC9A27.9000104@openwrt.org> <1271972321.12589.2.camel@mj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1271972321.12589.2.camel@mj>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 22, 2010 at 05:38:41PM -0400, Pavel Roskin wrote:
> On Mon, 2010-04-19 at 20:00 +0200, Felix Fietkau wrote:
> 
> > > can that happen when both ends are configured to a fixed rate of 11M?
> > No idea. I've never used fixed-rate. I guess it could, if it uses 11M
> > for communicating with a peer that it for some reason did not enable
> > this rate for.
> 
> I think if there is a legitimate condition when it can happen, we should
> not be using WARN_ON.

certainly there must be rate limitting before it hits any stable kernel.

Richard

