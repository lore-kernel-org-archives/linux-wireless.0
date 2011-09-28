Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:47305 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346Ab1I1Pxh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 11:53:37 -0400
Message-ID: <4E834128.2030208@neratec.com> (sfid-20110928_175340_551293_881581D2)
Date: Wed, 28 Sep 2011 17:45:44 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: "Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"Presman, Boris" <boris.presman@ti.com>,
	"Azulay, Assaf" <assaf@ti.com>
Subject: Regulatory revamp status
References: <CAB=NE6UcT8gzVWW+stLEy2SKBCdt-wVnv6aWOZBKTurXk1W0YA@mail.gmail.com>
In-Reply-To: <CAB=NE6UcT8gzVWW+stLEy2SKBCdt-wVnv6aWOZBKTurXk1W0YA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Luis,

I am referring to your announcement for a regulatory revamp at the LinuxWireless summit in Vancouver and the patches to add DFS information to CRDA you proposed quite some time ago in [1].

For the integration of DFS that is currently being worked out by TI, we will need to have the DFS regulatory domain for the selected countrycode available -- that basically was implemented with the named patch set.

Could you please give some info on the status of the regulatory revamp and particularly if the proposed DFS information will be part of it? One detail that came up in the discussion to your patches was whether DFS regulatory domains are constant for a countrycode or might differ between bands. Has this been clarified meanwhile?



Thanks
Zefir


[1] http://marc.info/?l=linux-wireless&m=129286456607063&w=2, referenced at http://linuxwireless.org/en/developers/DFS#Map_countries_to_a_DFS_region_bit
