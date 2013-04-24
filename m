Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sipsolutions.net ([144.76.43.152]:51434 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757092Ab3DXTTP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 15:19:15 -0400
Message-ID: <1366831150.21854.18.camel@jlt4.sipsolutions.net> (sfid-20130424_211920_469603_3CAABACC)
Subject: Re: Where is done the distintion between AP and mesh/adhoc on ath9k?
From: Johannes Berg <johannes@sipsolutions.net>
To: Francisco Cuesta <ndarkness@gmail.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Date: Wed, 24 Apr 2013 21:19:10 +0200
In-Reply-To: <CANMvdA9AzCjT7_-idDTXpMpjUcuC75bK57g7pwLFWefraSBETQ@mail.gmail.com> (sfid-20130424_210528_552454_753D7519)
References: <CANMvdA9AzCjT7_-idDTXpMpjUcuC75bK57g7pwLFWefraSBETQ@mail.gmail.com>
	 (sfid-20130424_210528_552454_753D7519)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

zOn Wed, 2013-04-24 at 21:05 +0200, Francisco Cuesta wrote:
> Hello,
> 
> I was wondering where I might find on the ath9k drivers the functions
> which let the device distinguish between AP mode and mesh/adhoc one.
> Could someone enlighten me a bit?

git grep NL80211_IFTYPE_

johannes

