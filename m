Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:50246 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756955Ab3AYMIs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 07:08:48 -0500
Received: by mail-wg0-f45.google.com with SMTP id dq12so190710wgb.12
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2013 04:08:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <A06A1995-B025-4841-BCD9-9A940DA58620@gmail.com>
References: <20121211100419.GA7822@earthship.arig>
	<A06A1995-B025-4841-BCD9-9A940DA58620@gmail.com>
Date: Fri, 25 Jan 2013 13:08:46 +0100
Message-ID: <CAGXE3d_6zsWDAQ6r9UR5jPa+a0iqWOqLEY1w6AoLBfszhqi1UQ@mail.gmail.com> (sfid-20130125_130851_753333_AF51F1C5)
Subject: Re: [PATCH 3/3] rt2x00: add platform_data mac address
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Daniel Golle <dgolle@allnet.de>,
	"<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
	"<users@rt2x00.serialmonkey.com>" <users@rt2x00.serialmonkey.com>,
	"<juhosg@openwrt.org>" <juhosg@openwrt.org>,
	"<sgruszka@redhat.com>" <sgruszka@redhat.com>,
	"<john@phrozen.org>" <john@phrozen.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, Dec 11, 2012 at 10:51 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> And for this patch I have the same question as for the previous patch: why do we need to arrange this via platform data,
> as opposed to using the standard user space ifconfig facility to set a mac address?

This looks fine to me. I'd also prefer to pass in a MAC address from
the platform data on SoC devices
instead of having to write some user space code. And this is how it is
done by other drivers as well.

> As a second question: why is this only implemented for rt61pci, and not the other PCI / SOC drivers?

Good point.

Helmut
