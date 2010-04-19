Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:64915 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab0DSRxw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 13:53:52 -0400
Received: by bwz19 with SMTP id 19so838bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 19 Apr 2010 10:53:50 -0700 (PDT)
Date: Mon, 19 Apr 2010 19:55:08 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: rc80211_minstrel.c:70 WARNING with 2.6.34-rc4
Message-ID: <20100419175508.GB5312@linux-m68k.org>
References: <20100418085653.GA7345@linux-m68k.org> <1271694855.9026.51.camel@mj> <20100419174100.GA5312@linux-m68k.org> <4BCC95CC.7030109@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4BCC95CC.7030109@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 19, 2010 at 07:41:32PM +0200, Felix Fietkau wrote:


> This warning typically shows up, whenever the driver reports a rate to
> minstrel in the tx status that is not part of the supported/negotiated
> rate set - that's the reason the index lookup above fails.

can that happen when both ends are configured to a fixed rate of 11M?

Richard
