Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:48812 "EHLO
        emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935677AbcKXTBq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Nov 2016 14:01:46 -0500
Date: Thu, 24 Nov 2016 20:46:01 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Sebastian Reichel <sre@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Michal Kazior <michal.kazior@tieto.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: wl1251 & mac address & calibration data
Message-ID: <20161124184601.wo4al6nyzb6rmiqs@raspberrypi-2.musicnaut.iki.fi> (sfid-20161124_200216_820284_73BDC3D3)
References: <201611111820.52072@pali>
 <201611221805.13606@pali>
 <20161123222335.GA4788@amd>
 <201611232339.59411@pali>
 <20161124075104.GA26721@amd>
 <20161124083329.GB13735@pali>
 <20161124151317.34yoza3dzuh46oa4@earth>
 <20161124152045.GK13735@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20161124152045.GK13735@pali>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Nov 24, 2016 at 04:20:45PM +0100, Pali Rohár wrote:
> Proprietary, signed and closed bootloader NOLO does not support DT. So
> for booting you need to append DTS file to kernel image.
> 
> U-Boot is optional and can be used as intermediate bootloader between
> NOLO and kernel. But still it has problems with reading from nand, so
> cannot read NVS data nor MAC address.

You could use kexec to pass the fixed DT.

A.
