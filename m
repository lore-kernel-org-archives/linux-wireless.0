Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:52832 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab0KVGCQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 01:02:16 -0500
Subject: RE: [PATCH 1/2] wl1271: Prevent ad-hoc and active scanning on 11a
 DFS frequencies
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: "ext Gabay, Benzy" <benzyg@ti.com>
Cc: "luciano.coelho@nokia.com" <luciano.coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <676FD6AA0F002F49B89E70F0C5EFD22C136DEA03CC@dlee04.ent.ti.com>
References: <1289384840-28305-1-git-send-email-juuso.oikarinen@nokia.com>
	 <676FD6AA0F002F49B89E70F0C5EFD22C136DEA03B9@dlee04.ent.ti.com>
	 <1289977249.2522.148.camel@wimaxnb.nmp.nokia.com>
	 <676FD6AA0F002F49B89E70F0C5EFD22C136DEA03CC@dlee04.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 10:34:36 +0200
Message-ID: <1289982876.2522.157.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-17 at 02:25 -0600, ext Gabay, Benzy wrote:
> Yet another question on this topic,
> Ad-Hoc was designed originally for B mode only. Some companies extended it to G also. 
> Do we have MAC802.11 support for Ad-Hoc on 11a channels these days?

Based on our testing, ad-hoc on 11a appears to work, tested between two
linux-based devices.

-Juuso


