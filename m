Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58088 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913AbbAFI3i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 03:29:38 -0500
Message-ID: <1420532972.1966.4.camel@sipsolutions.net> (sfid-20150106_092942_350423_E509F98E)
Subject: Re: b43 driver and WEP (solved)
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Erich Titl <erich.titl@think.ch>, linux-wireless@vger.kernel.org
Date: Tue, 06 Jan 2015 09:29:32 +0100
In-Reply-To: <54AB31EB.6020801@lwfinger.net> (sfid-20150106_015306_425223_200E98E0)
References: <54AA5438.9070902@think.ch> <54AAFFB1.8030109@lwfinger.net>
	 <54AB2405.3050602@think.ch> <54AB31EB.6020801@lwfinger.net>
	 (sfid-20150106_015306_425223_200E98E0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-01-05 at 18:52 -0600, Larry Finger wrote:

> Glad you found it. Strange that loading mac80211 did not force loading. Have you 
> run 'depmod -a' on the modules?

I believe that mac80211 doesn't have a strong dependency on the module -
it just loads the crypto algorithm at runtime.

In fact, IIRC this was even required/desired for FIPS mode in RHEL or
so.

johannes

