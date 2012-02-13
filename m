Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41092 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab2BMNp4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 08:45:56 -0500
Received: by pbcun15 with SMTP id un15so4560345pbc.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Feb 2012 05:45:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F390ED3.8010400@openwrt.org>
References: <4F390ED3.8010400@openwrt.org>
Date: Mon, 13 Feb 2012 14:45:56 +0100
Message-ID: <CAGXE3d90az_g3KyzPp-4NQoM2zmXaNSVo=7piM=q8EK9WdBp7A@mail.gmail.com> (sfid-20120213_144600_351887_4E76CC09)
Subject: Re: Poor RT2880 performance
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com, gwingerde@gmail.com,
	Ivo Van Doorn <ivdoorn@gmail.com>,
	Andreas Hartmann <andihartmann@freenet.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, Feb 13, 2012 at 2:23 PM, Florian Fainelli <florian@openwrt.org> wrote:
> I am playing with a RT2880-F based AP, with a N connected station, in a
> residential environment.

Mind to provide the RF and RT chipset identifications? rt2x00 should print them
out during module load (at least when compiled with debugging options).

> I could not get more than 26Mbits/sec TCP performance using iperf on both
> sides,

Did aggregation kick in? What rate was selected by the AP?

> changing to a busier channel even made the performance drop down to
> 5Mbits/sec, and remained like this.

Andreas also reported some issues as soon as the environment gets noisy,
not sure what the root cause for this is :(

Helmut
