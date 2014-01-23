Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45793 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaAWP7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 10:59:05 -0500
Message-ID: <1390492742.4142.35.camel@jlt4.sipsolutions.net> (sfid-20140123_165910_256894_B0A4458F)
Subject: Re: Issue with authentication to Aerohive APs
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Bateman <steven@fndtn.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
Date: Thu, 23 Jan 2014 16:59:02 +0100
In-Reply-To: <CF02A704.17362%steven@fndtn.com>
References: <CF02A704.17362%steven@fndtn.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-01-20 at 16:27 +0000, Steven Bateman wrote:
> You're right, I did accidentally filter out acks. I have an updated
> filtered capture attached.
> 
> It could be either, but I'm going off of wpa_supplicant instructing to
> transmit the 2nd EAPOL frame, but it never showing up in the air. The
> consultations I've received so far indicated that it would more likely be
> a driver/firmware issue, but I don't have enough experience with Linux
> supplicants to be sure about that.

Ohh. Ok. Yeah then it's most likely a driver bug. Hmm. I vaguely
remember bugs like this but I thought they were all fixed.

Is there any chance you could try to put the particular AP into 2.4 GHz?
Although I guess you have similar APs on 2.4 GHz channels that work?
Could you (or the user actually running into the problem) collect
tracing maybe?
http://wireless.kernel.org/en/developers/Documentation/mac80211/tracing

johannes

