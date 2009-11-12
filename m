Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:38762 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760040AbZKLCzr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2009 21:55:47 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 11 Nov 2009 18:55:53 -0800
Date: Wed, 11 Nov 2009 18:55:49 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Zheng, Jeff" <jeff.zheng@intel.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"Wifi-test-devel@lists.sourceforge.net"
	<Wifi-test-devel@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wifi-test: add initial simple test scripts
Message-ID: <20091112025549.GF3976@tux>
References: <1257989758-30756-1-git-send-email-lrodriguez@atheros.com> <154E55ADF9629D4E8D13F08BF92ABEB63FDC9833CF@PDSMSX501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <154E55ADF9629D4E8D13F08BF92ABEB63FDC9833CF@PDSMSX501.ccr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 11, 2009 at 06:31:41PM -0800, Zheng, Jeff wrote:
> Thanks Luis, I have checked it in.
> 
> Do these scripts (client and AP) run on the same machine? If yes, will
> packets be sent/received through air, or through mac80211 as bridge?

This is intended to run on two separate machines.

> I have a sample case with hwsim (hwsim.sh), which simulates two wlan
> interface (one for client and one for hostapd). It can be used for
> testing mac80211.

Neat :)

  Luis
