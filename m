Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46044 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbaBJOhb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 09:37:31 -0500
Message-ID: <1392043046.4128.20.camel@jlt4.sipsolutions.net> (sfid-20140210_153734_326272_727C02CE)
Subject: Re: [PATCH 2/8] iwlwifi: mvm: disable scheduled scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Mon, 10 Feb 2014 15:37:26 +0100
In-Reply-To: <52F8E27D.6020601@broadcom.com>
References: <52EFFCE8.6070505@gmail.com>
		 <1391459962-7381-2-git-send-email-egrumbach@gmail.com>
		 <52F5FC02.8050508@broadcom.com>
	 (sfid-20140208_104235_514359_C8CEB8F3) <1392019923.4128.0.camel@jlt4.sipsolutions.net>
	 <52F8E27D.6020601@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-02-10 at 15:30 +0100, Arend van Spriel wrote:

> > You may decide to not care - newer supplicant seems to always cancel
> > scheduled scan first (although that should never have been required,
> > Broadcom's proprietary Android driver also behaves to require that.)
> 
> When implementing scheduled scan, I found our firmware can handle a
> regular scan regardless whether a scheduled scan is active or not.

Interesting. I wonder why the other broadcom folks went to
wpa_supplicant to make it cancel scheduled scan ... well, actually, I
don't care all that much :-D

johannes

