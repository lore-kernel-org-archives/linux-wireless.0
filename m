Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:58784 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759583AbYHFUez (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 16:34:55 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: kernel panic on p54pci insertion on mipsel
Date: Wed, 6 Aug 2008 22:34:10 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>, Chr <chunkeey@web.de>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>
References: <4898B018.5050202@wpkg.org> <1218053763.23048.67.camel@johannes.berg> <489A0970.9030104@wpkg.org>
In-Reply-To: <489A0970.9030104@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808062234.10794.mb@bu3sch.de> (sfid-20080806_223515_258122_D9F842C3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 06 August 2008 22:28:32 Tomasz Chmielewski wrote:
> Johannes Berg schrieb:
> >> Call Trace:[<8018405c>][<8001d2bc>][<8004cc30>][<8004e0dc>][<80002ca4>][<8001c310>][<80001e54>][<80002ca4>][<80125850>][<c0070c00>][<c0070c98>][<c007118c>]
> >>
> >> Code: 8ca40150  24020001  afa20010 <8c820078> 00a08021  30420200  1440009f  8cb10160  8c820010
> >> Kernel panic - not syncing: Fatal exception in interrupt
> > 
> > Please remove me from the CC list, at least until you've discovered
> > ksymoops.
> 
> Sorry for that. Is this one more helpful?

No, you seem to be using the wrong System.map and/or vmlinux image.
Read the manpage, please.


-- 
Greetings Michael.
