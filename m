Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:54081 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaAXC2q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 21:28:46 -0500
From: "Liu, Bopeng" <Bopeng.Liu@windriver.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Steven Bateman <steven@fndtn.com>
CC: Linux Wireless <linux-wireless@vger.kernel.org>
Subject: RE: Issue with authentication to Aerohive APs
Date: Fri, 24 Jan 2014 02:28:39 +0000
Message-ID: <DE84205DFC6FCF4A904A2F75D822FABA558C3D2D@ALA-MBB.corp.ad.wrs.com> (sfid-20140124_032849_205210_523A1F03)
References: <CF02A704.17362%steven@fndtn.com>,<1390492742.4142.35.camel@jlt4.sipsolutions.net>
In-Reply-To: <1390492742.4142.35.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I met a problem when I set to 5Mhz

Mode A can't work...

Do you have some ideas on this issue? 

Best Regards.
--------------------------------------
Bopeng Liu
WIND RIVER | China Development Center
Phone: 8610-6483-5012



________________________________________
From: linux-wireless-owner@vger.kernel.org [linux-wireless-owner@vger.kernel.org] on behalf of Johannes Berg [johannes@sipsolutions.net]
Sent: Thursday, January 23, 2014 11:59 PM
To: Steven Bateman
Cc: Linux Wireless
Subject: Re: Issue with authentication to Aerohive APs

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

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
