Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:63690 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750872Ab2JOOvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 10:51:03 -0400
Message-ID: <1350312660.1516.34.camel@x61.thuisdomein> (sfid-20121015_165107_134992_D954DBD5)
Subject: Re: [iwl4965] Microcode SW error detected
From: Paul Bolle <pebolle@tiscali.nl>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Bernhard Schmidt <bschmidt@freebsd.org>,
	linux-wireless@vger.kernel.org
Date: Mon, 15 Oct 2012 16:51:00 +0200
In-Reply-To: <1347625024.14216.28.camel@x61.thuisdomein>
References: <1306151106.2066.60.camel@x61.thuisdomein>
	 <201106070832.49048.bschmidt@freebsd.org>
	 <20110607145435.GA5179@redhat.com>
	 <1315124915.5239.21.camel@x61.thuisdomein>
	 <20110905093349.GE2221@redhat.com>
	 <1347625024.14216.28.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-09-14 at 14:17 +0200, Paul Bolle wrote:
> 0) It's one year later now and this Microcode SW error again showed up
> in the logs. I recently upgraded and I haven't kept any logs, but my
> guess would be that I have run into that error once every week. (This
> laptop is now running a v3.5.3 based kernel as shipped for Fedora 17.)
> 
> 1) Would you have any suggestions how to pinpoint the cause of this
> error? It is mainly annoying, and I managed to ignore it since my
> previous message, but I still would like to free the logs from the noise
> it makes.

0) I ported the "iwlegacy_tracing" patch from
https://bugzilla.kernel.org/show_bug.cgi?id=42766 to v3.6-rc7 and to
iwl4965. I've been running iwl4965 with tracing enabled ever since (that
is on: v3.6-rc7, v3.6, v3.6.1, and v3.6.2). Finally, after only three
weeks I hit our Microcode SW error again.

1) So now I've got a 600+k line (or 65 MB) trace dump. What should I do
with it?


Paul Bolle

