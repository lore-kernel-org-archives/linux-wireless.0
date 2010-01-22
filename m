Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:15271 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066Ab0AVWKs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 17:10:48 -0500
Subject: Re: Compat-wireless bleeding-edge daily builds broken since
 2009-12-11
From: Pavel Roskin <proski@gnu.org>
To: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	Peter Svensson <petersv@psv.nu>, linux-wireless@vger.kernel.org
In-Reply-To: <4B5A20C3.6020304@redfish-solutions.com>
References: <Pine.LNX.4.64.0912261245080.5112@cheetah.psv.nu>
	 <20091229020027.GE30201@bombadil.infradead.org>
	 <4B59FC5E.1020802@redfish-solutions.com>
	 <43e72e891001221153w5c4c4bc6g63883b5012d384b7@mail.gmail.com>
	 <4B5A20C3.6020304@redfish-solutions.com>
Content-Type: text/plain
Date: Fri, 22 Jan 2010 17:10:40 -0500
Message-Id: <1264198240.9056.4.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-01-22 at 14:03 -0800, Philip A. Prindeville wrote:
> Call Trace:
>  [<d09cb62e>] ieee80211_tx_prepare+0x2ed/0x327 [mac80211]

I assume it's the hostapd bug that was fixed minutes ago.  Alternatively
(but less likely), it's a bug in WEP, also fixed today.  Please see the
current mailing list archives.

You may want to enable CONFIG_MAC80211_DEBUG_MENU and
CONFIG_MAC80211_NOINLINE to get more reasonable backtraces.

-- 
Regards,
Pavel Roskin
