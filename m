Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:43588 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760001AbZKZAaT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 19:30:19 -0500
Message-ID: <4B0DCC15.3090506@openwrt.org>
Date: Thu, 26 Nov 2009 01:30:13 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Gabor Juhos <juhosg@openwrt.org>,
	John Linville <linville@tuxdriver.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [PATCH] ath9k: enable 2GHz band only if the device
 supports it
References: <1259180955-2145-1-git-send-email-juhosg@openwrt.org> <20091125213857.GM5006@tux>
In-Reply-To: <20091125213857.GM5006@tux>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Wed, Nov 25, 2009 at 12:29:15PM -0800, Gabor Juhos wrote:
>> Currently, the 2GHz band is enabled unconditionally, even if the device
>> does not support it.
> 
> This is true, but we don't have any 11n 5 GHz only devices,
> The patch is fine too though but it'd be better if you fail
> with a proper ath_print ATH_DBG_FATAL message if neither band
> has been marked as supported.
We do have some ;)
Ubiquiti Networks has a few Python+Merlin based devices that are 5GHz
only, and we're working on supporting them.

- Felix
