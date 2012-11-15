Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plout10-01.prod.sin2.secureserver.net ([182.50.145.4]:44310
	"HELO sg2plout10-01.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1768435Ab2KORhn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 12:37:43 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20645.10318.653310.433256@gargle.gargle.HOWL> (sfid-20121115_183746_240897_F5A3DD2D)
Date: Thu, 15 Nov 2012 23:07:18 +0530
To: <paul@foresight-mands.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: Debugging support
In-Reply-To: <085801cdc355$6abcb180$40361480$@com>
References: <085801cdc355$6abcb180$40361480$@com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Paul Stoaks wrote:
> Hi Folks,
> 
> I have another noob question for you.  Can you point me to documentation for
> the protocol-level debugging facilities built into mac80211 (and/or
> drivers)?  I see references to "debugfs" and some ath9k debugging features,
> some of which are enabled in the kernel configuration.  What I'm
> particularly interested in at this point is any kind of protocol or
> management packet logging as well as mac80211 event logging.  I have some
> ath9k hardware, but I also have Broadcom B43 devices that I'd like to
> monitor.

mac80211 has tracing:
http://wireless.kernel.org/en/developers/Documentation/mac80211/tracing

wpa_supplicant has tracing:
(Enable CONFIG_DEBUG_LINUX_TRACING in wpa_s).

Event monitoring in "iw" is useful too.

ath9k doesn't have tracing or packet-logging currently.

Sujith
