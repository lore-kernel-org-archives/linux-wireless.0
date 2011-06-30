Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:56791 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751097Ab1F3Nuh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 09:50:37 -0400
Date: Thu, 30 Jun 2011 16:50:30 +0300
From: Jouni Malinen <j@w1.fi>
To: alfred steele <alfred.jaquez@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: STA Driver/MLME handling for broadcast DEAUTHENTICATE from AP
Message-ID: <20110630135030.GA15540@jm.kir.nu> (sfid-20110630_155042_141889_6C6F8ED5)
References: <BANLkTi=oxo6ryCaJZiF9NZSV7hA1DJqqSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BANLkTi=oxo6ryCaJZiF9NZSV7hA1DJqqSw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 28, 2011 at 02:59:04PM -0500, alfred steele wrote:
> I have a quick question. How should be a broadcast deauthenticate from
> an AP handled by a client driver and or MLME.
> Is it the same way as a unicast deauth is ahandled.

Yes, if the broadcast Deauthentication frame has a matching BSSID, the
station should process it just like it would a unicast one directed to
it.
 
-- 
Jouni Malinen                                            PGP id EFC895FA
