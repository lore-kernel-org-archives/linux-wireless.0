Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:33294 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbcCDGc0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 01:32:26 -0500
Received: by mail-wm0-f49.google.com with SMTP id l68so6867861wml.0
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2016 22:32:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <E1abfnE-0000VS-00@www.xplot.org>
References: <1456492163-11437-1-git-send-email-michal.kazior@tieto.com>
	<E1abfnE-0000VS-00@www.xplot.org>
Date: Fri, 4 Mar 2016 07:32:24 +0100
Message-ID: <CA+BoTQk6J7kgdie9aX24MB+8PxN3oFUh0eVdmVrdyptW5RxQXg@mail.gmail.com> (sfid-20160304_073232_866515_3B4C3F4D)
Subject: Re: [RFC/RFT] mac80211: implement fq_codel for software queuing
From: Michal Kazior <michal.kazior@tieto.com>
To: Tim Shepard <shep@alum.mit.edu>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Network Development <netdev@vger.kernel.org>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Dave Taht <dave.taht@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Felix Fietkau <nbd@openwrt.org>, andrewmcgr@google.com,
	apenwarr@google.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 March 2016 at 03:48, Tim Shepard <shep@alum.mit.edu> wrote:
[...]
> (I am interested in knowing what other mac80211 drivers have been
>  modified to use the mac80211 intermediate software queues.   I know
>  Michal mentioned he has patches for ath10k that are not yet released,
>  and I know Felix is finishing up the mt76 driver which uses them.)

Patches for ath10k are under review since quite some time now (but are
not merged yet). The latest re-spin is:

  http://lists.infradead.org/pipermail/ath10k/2016-March/006923.html


Michał
