Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:44594 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbXDDQZp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2007 12:25:45 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HZ8Gd-0006wn-HH
	for linux-wireless@vger.kernel.org; Wed, 04 Apr 2007 12:23:27 -0400
Subject: Re: Orinoco, mac80211 and wpa2
From: Pavel Roskin <proski@gnu.org>
To: Jouni Malinen <jkm@devicescape.com>
Cc: Dan Williams <dcbw@redhat.com>, Jan Dittmer <jdi@l4x.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070404153814.GC8229@devicescape.com>
References: <4613A4A9.1060902@l4x.org>
	 <1175697737.2656.3.camel@localhost.localdomain>
	 <1175700158.5322.9.camel@dv>  <20070404153814.GC8229@devicescape.com>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 12:25:38 -0400
Message-Id: <1175703938.5322.21.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-04-04 at 08:38 -0700, Jouni Malinen wrote:

> If Orinoco cards added WPA support in the same (or similar) way as
> Intersil Prism2/2.5/3, firmware support is certainly needed. In case of
> Intersil, it was needed for adding WPA/RSN IE into (Re)AssocReq and to
> receive Beacon/ProbeResp frames (to get WPA/RSN IE from AP). 

Since Orinoco 9.xx firmware has explicit support for WPA (at least for
TKIP), I guess it could be used for that with or without mac80211.

Another approach would be to send beacons and other management frames
from the host software, but I'm afraid the firmware would get in the way
somewhere.

> In addition, the firmware must allow host-based encryption/decryption to be
> enabled.

That's not a problem.

-- 
Regards,
Pavel Roskin

