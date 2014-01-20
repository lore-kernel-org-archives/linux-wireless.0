Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59758 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaATKdL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 05:33:11 -0500
Message-ID: <1390213987.4335.5.camel@jlt4.sipsolutions.net> (sfid-20140120_113315_586887_422359EC)
Subject: Re: FW: Issue with authentication to Aerohive APs
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Bateman <steven@fndtn.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
Date: Mon, 20 Jan 2014 11:33:07 +0100
In-Reply-To: <CEF450DF.167F3%steven@fndtn.com> (sfid-20140109_201358_587746_18A9EB82)
References: <CEF439BF.167DB%steven@fndtn.com>
	 <CEF44F30.167EB%steven@fndtn.com> <CEF450DF.167F3%steven@fndtn.com>
	 (sfid-20140109_201358_587746_18A9EB82)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-09 at 19:13 +0000, Steven Bateman wrote:

> I'm writing on behalf of about 4 or 5 users that are having issues
> connecting to a WLAN that I manage. The majority of the information can be
> found at the following link, including relevant logs. I've enclosed the
> packet capture from next to the station with failed authentications.

How did you capture/filter the attached file? It shows no
acknowledgement of the EAPOL packets, but no retries either, so you
probably filtered out the acknowledgements. That leads me to believe
that maybe there was something wrong with those EAPOL frames, maybe
wpa_supplicant didn't get or didn't expect them?

What makes you so sure it's a driver/firmware bug rather than a bug
related to wpa_supplicant or interaction with it?

johannes

