Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:46134 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab3IJNzO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 09:55:14 -0400
Received: by mail-oa0-f46.google.com with SMTP id o20so7773672oag.5
        for <linux-wireless@vger.kernel.org>; Tue, 10 Sep 2013 06:55:11 -0700 (PDT)
Date: Tue, 10 Sep 2013 08:55:09 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Performance problems with Netgear WNDAP350
Message-ID: <20130910135509.GA4501@thinkpad-t410> (sfid-20130910_155519_197451_B655E418)
References: <20130909212544.GA27771@thinkpad-t410>
 <21038.55900.901542.571888@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <21038.55900.901542.571888@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 10, 2013 at 02:07:48PM +0530, Sujith Manoharan wrote:
> Seth Forshee wrote:
> > I posted some wireshark traces in case someone else can find something
> > else informative that I've missed. They're at
> > http://people.canonical.com/~sforshee/wndap350/:
> > 
> >  * iperf-iwlwifi.pcapng.gz: Trace from iperf client on Linux STA with
> >    iwlwifi
> >  * iperf-server.pcapng.gz: Trace from the iperf server for the same test
> >    as iperf-iwlwifi
> >  * iperf-osx.pcapng.gz: Trace from iperf client on OSX, using Broadcom
> >    wireless
> 
> The link with the iwlwifi client seems to be drowning in RTS/CTS exchanges
> compared with the osx client.
> 
> iwlwifi: total: 109087, RTS - 9782 (9.0 %)
> osx:     total: 522581, RTS - 8366 (1.6 %)

Yes, but I don't think that's behind the APs failure to send us frames
for long periods of time. I can better compare the RTS/CTS exchanges
between the two when I can get an otherwise stable connection to the AP
from Linux.

Seth
