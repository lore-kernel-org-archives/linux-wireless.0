Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35404 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab2AaFxl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 00:53:41 -0500
Message-ID: <4F2781B4.9080004@sipsolutions.net> (sfid-20120131_065343_464964_BA9FF6C8)
Date: Mon, 30 Jan 2012 21:52:52 -0800
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Victor Goldenshtein <victorg@ti.com>
CC: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name
Subject: Re: [RFC 8/9] mac80211: add DFS capabilities flag
References: <1327581484-22047-1-git-send-email-victorg@ti.com> <1327581484-22047-9-git-send-email-victorg@ti.com>
In-Reply-To: <1327581484-22047-9-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/26/2012 4:38 AM, Victor Goldenshtein wrote:
> Add new IEEE80211_HW_SUPPORTS_RADAR_DETECTION attribute which
> indicates that hw supports radar detection.

No need, driver can set the nl80211 flags directly.

johannes
