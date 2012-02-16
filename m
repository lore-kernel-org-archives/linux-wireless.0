Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036Ab2BPMDR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Feb 2012 07:03:17 -0500
Date: Thu, 16 Feb 2012 13:03:04 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Pedro Francisco <pedrogfrancisco@gmail.com>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: iwl3945: WPA2+swcrypto=0: receives broadcast only
Message-ID: <20120216120303.GD25833@redhat.com> (sfid-20120216_130326_346557_91E445EF)
References: <CAJZjf_y_fSYv0U8y8APLJAvWe=xKWpa_poLc9h7qjQuRSj_rGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJZjf_y_fSYv0U8y8APLJAvWe=xKWpa_poLc9h7qjQuRSj_rGw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Mon, Feb 06, 2012 at 06:41:21PM +0000, Pedro Francisco wrote:
> When I connect to a WPA2 AP with swcrypto=0 I get the following kinds
> of traffic:
> ARP (Broadcast)
> DHCP (255.255.255.255)
> IGMP (224.0.0.22 and 224.0.0.1)
> 
> If I do a normal DHCP, I get no response. If I do "dhclient -B",
> requesting BOOTP broadcast flag, I get an IP, as expected. However ARP
> requests go unresponded as expected.
> 
> The closest I've found relative to this is
> http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=1872 . It is
> however reported as fixed on *both* "software/hardware crypto with
> WPA2 PSK and EAP" (2009-01-06).
> 
> It seems curious I can receive broadcast traffic but not traffic specific to me.
Brodcast traffic encrypted with different key, but perhaps there are
some more differences.

I think that hw crypto problems can be fixed only in firmware, but I'm
not sure.

> I'd present the debug of iwl3945 but apparently that option was
> removed from iwl3945 module?
??? absolutily not, perhaps you did not compile CONFIG_IWLEGACY_DEBUG=y ?

Stanislaw
