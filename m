Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3980 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979Ab1KIVuQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 16:50:16 -0500
Message-ID: <4EBAF593.4010502@broadcom.com> (sfid-20111109_225020_198465_BA5B4F5D)
Date: Wed, 9 Nov 2011 22:50:11 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Arik Nemtsov" <arik@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 3.2-rc1: system locks up upon inserting brcmsmac
References: <4EBAF088.2040406@broadcom.com>
 <1320874522.3845.109.camel@jlt3.sipsolutions.net>
In-Reply-To: <1320874522.3845.109.camel@jlt3.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/09/2011 10:35 PM, Johannes Berg wrote:
> if (info->control.hw_key && info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)

Yep. That does the trick for me ;-)

Gr. AvS

