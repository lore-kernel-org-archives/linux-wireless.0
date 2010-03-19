Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44044 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab0CSPAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 11:00:10 -0400
Date: Fri, 19 Mar 2010 10:56:37 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCHv3 0/2] mac80211: cfg80211: Roam trigger support
Message-ID: <20100319145636.GB9552@tuxdriver.com>
References: <1268830877-5162-1-git-send-email-juuso.oikarinen@nokia.com> <20100317132236.GC2990@tuxdriver.com> <87aau4dcfm.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87aau4dcfm.fsf@purkki.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 19, 2010 at 08:59:25AM +0200, Kalle Valo wrote:
> "John W. Linville" <linville@tuxdriver.com> writes:

> > Will applications actually use it?
> 
> The idea is that wpa_supplicant will listen to these events, and will
> enable or disable backround scan (ie. scanning for new APs when
> associated) based on information received from the events. When the
> connection to the AP is good enough, it can disable background scan
> which makes it possible to save power and also get rid of latency
> introduced by the background scan.
> 
> I haven't seen any implementation for wpa_supplicant yet, but we have
> talked about that few times during the last two years.

If you can make wpa_supplicant scan less then I am sold! :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
