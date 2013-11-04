Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056Ab3KDU3X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Nov 2013 15:29:23 -0500
Message-ID: <1383596955.29469.2.camel@dcbw.foobar.com> (sfid-20131104_212926_823135_D3593796)
Subject: Re: orinoco (Lucent/Agere 9.48) unable to connect
From: Dan Williams <dcbw@redhat.com>
To: zaphod@berentweb.com
Cc: linux-wireless@vger.kernel.org
Date: Mon, 04 Nov 2013 14:29:15 -0600
In-Reply-To: <CAPSTskvZALnaNYfBxCx_fFhYuTPW8AOVkyN9DTBeErfO67hQBw@mail.gmail.com>
References: <CAPSTskvByfGWTyDmq9WeX7Em1N0DAAZ3eKDV5eV6qfkH2gDzdA@mail.gmail.com>
	 <1383581905.17589.0.camel@dcbw.foobar.com>
	 <CAPSTskvZALnaNYfBxCx_fFhYuTPW8AOVkyN9DTBeErfO67hQBw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-11-04 at 20:42 +0200, Beeblebrox wrote:
> > What kind of access point are you trying to connect to?  These devices
> > only support 802.11b, so if the access point is newer and is using
> > 802.11n, there are some 11n configurations that simply don't support
> > connections from 11b clients.
> > Dan
> 
> Hi Dan, thanks for your answer.
> The test A/P is a USR-5451-maxG with ddwrt as OS. A/P is on mixed mode
> (B+G), but after your mail I tried B-Only mode, which failed also.
> While observing the connection process, I got the feeling that the
> orinoco card (eth1) is unable to set an IP. I have tried static and
> dhclient, with same effect. Shortly after the connection process
> starts, the card status shows as connected, but does not finalize .
> Process then terminates (assuming because no IP is agreed on with AP).
> 
> Please advise what other info/test I can try.

If you're able, can you use wireshark on another computer to capture the
802.11 frames exchanged between the orinico device and the AP?

Dan

