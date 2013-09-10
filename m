Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:56082 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab3IJIlk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 04:41:40 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21038.55900.901542.571888@gargle.gargle.HOWL> (sfid-20130910_104145_036806_2FC05CFE)
Date: Tue, 10 Sep 2013 14:07:48 +0530
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Performance problems with Netgear WNDAP350
In-Reply-To: <20130909212544.GA27771@thinkpad-t410>
References: <20130909212544.GA27771@thinkpad-t410>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Seth Forshee wrote:
> I posted some wireshark traces in case someone else can find something
> else informative that I've missed. They're at
> http://people.canonical.com/~sforshee/wndap350/:
> 
>  * iperf-iwlwifi.pcapng.gz: Trace from iperf client on Linux STA with
>    iwlwifi
>  * iperf-server.pcapng.gz: Trace from the iperf server for the same test
>    as iperf-iwlwifi
>  * iperf-osx.pcapng.gz: Trace from iperf client on OSX, using Broadcom
>    wireless

The link with the iwlwifi client seems to be drowning in RTS/CTS exchanges
compared with the osx client.

iwlwifi: total: 109087, RTS - 9782 (9.0 %)
osx:     total: 522581, RTS - 8366 (1.6 %)

Sujith
