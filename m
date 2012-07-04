Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.u-psud.fr ([129.175.33.42]:36268 "EHLO smtp2.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987Ab2GDNpK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 09:45:10 -0400
Message-ID: <4FF448E5.5040404@lri.fr> (sfid-20120704_154515_714674_DD0A7509)
Date: Wed, 04 Jul 2012 15:45:09 +0200
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH v2] mac80211: tx: do not drop non-robust mgmt to non-MFP
 stas.
References: <1341393221-5396-1-git-send-email-cavallar@lri.fr>  <1341394528.4482.4.camel@jlt3.sipsolutions.net> <4FF414D9.4060509@lri.fr> <1341396753.4482.13.camel@jlt3.sipsolutions.net> <4FF43E53.6050805@lri.fr>
In-Reply-To: <4FF43E53.6050805@lri.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/07/2012 15:00, Nicolas Cavallari wrote:
But in a IBSS with RSN, if wpa_supplicant
> isn't recent enough, stations are always authorized by default. so
> drop_encrypted is required in this case.

drop_unencrypted, my bad.
