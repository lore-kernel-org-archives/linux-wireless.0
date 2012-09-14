Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:4829 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752918Ab2INMRO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 08:17:14 -0400
Message-ID: <1347625024.14216.28.camel@x61.thuisdomein> (sfid-20120914_141718_999871_FB317E0E)
Subject: Re: [iwl4965] Microcode SW error detected
From: Paul Bolle <pebolle@tiscali.nl>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Bernhard Schmidt <bschmidt@freebsd.org>,
	linux-wireless@vger.kernel.org
Date: Fri, 14 Sep 2012 14:17:04 +0200
References: <1306151106.2066.60.camel@x61.thuisdomein>
	 <201106070832.49048.bschmidt@freebsd.org>
	 <20110607145435.GA5179@redhat.com>
	 <1315124915.5239.21.camel@x61.thuisdomein>
	 <20110905093349.GE2221@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-09-05 at 12:32 +0200, Paul Bolle wrote:
> On Mon, 2011-09-05 at 11:33 +0200, Stanislaw Gruszka wrote:
> > Does wifi stop working after an
> > error, or there is some other negative impact? Or only that messages
> > are printed and driver recover itself?
> 
> There doesn't seem to be any impact (ie, it might have some impact but
> I'm too insensitive to notice). The driver does recover itself and I do
> not have to mess with rfkill or "modprobe -r" or whatever. I actually
> discovered this because I tend to regularly do
>     dmesg -r |  grep "^<[123]>"
> 
> to keep myself informed of any kernel errors (or worse). And then these
> few dozen lines can't go unnoticed.

0) It's one year later now and this Microcode SW error again showed up
in the logs. I recently upgraded and I haven't kept any logs, but my
guess would be that I have run into that error once every week. (This
laptop is now running a v3.5.3 based kernel as shipped for Fedora 17.)

1) Would you have any suggestions how to pinpoint the cause of this
error? It is mainly annoying, and I managed to ignore it since my
previous message, but I still would like to free the logs from the noise
it makes.


Paul Bolle

