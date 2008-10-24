Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36699 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751040AbYJXNmB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 09:42:01 -0400
Message-ID: <4901D0A5.7060707@gmx.de> (sfid-20081024_154208_694707_4376F569)
Date: Fri, 24 Oct 2008 15:41:57 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Linux-Kernel <linux-kernel@vger.kernel.org>,
	otus-devel@lists.madwifi-project.org
Subject: Re: [otus-devel] Release of Atheros 802.11n USB Linux driver
References: <43e72e890810211904x7bd243dem68dfcfe7a795ec6f@mail.gmail.com> <43e72e890810231637v51591edak5345faccd81d594b@mail.gmail.com>
In-Reply-To: <43e72e890810231637v51591edak5345faccd81d594b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/24/2008 01:37 AM, Luis R. Rodriguez wrote:

> So for those of you who want to know which devices to buy

I'd guess the

* AVM FRITZ!WLAN N USB Stick (USB ID 0x57c, 0x8401)

should be in this list, too.

I don't own one (yet), but the Windows driver contains:
$ strings -t x fwlanusbn_wxp.sys
...
4de20 Atheros OTUS Wireless Network Adapter
...

Could some owner please confirm the chipset of this stick?

