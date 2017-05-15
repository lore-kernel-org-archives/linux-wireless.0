Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50502 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932311AbdEOI0T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 May 2017 04:26:19 -0400
Date: Mon, 15 May 2017 10:24:31 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Marek =?utf-8?Q?Floria=C5=84czyk?= <marek.florianczyk@gmail.com>
Cc: linux-wireless@vger.kernel.org, hostap@lists.infradead.org
Subject: Re: Cubieboard2 + hostapd + 100 wireless devices
Message-ID: <20170515082430.GA8370@redhat.com> (sfid-20170515_102622_650155_214F59A4)
References: <1946348.9jam7OIK4C@franki>
 <20170510093113.GA9584@redhat.com>
 <1703928.J8ZF87vcpf@franki>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1703928.J8ZF87vcpf@franki>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Wed, May 10, 2017 at 04:30:35PM +0200, Marek Floriańczyk wrote:
> I'm running hostapd in debug mode now, and I have found station:
> 2c:3a:e8:00:33:e0
> That deauthenticate with AP, but I don't know why, 
> reason_code=3 "station is leaving (or has left) IBSS or ESS"

Not sure about ESP module, but mac80211 sends deauth frame with reason=3
among some other cases when system suspend.

Stanislaw
