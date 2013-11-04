Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f50.google.com ([209.85.128.50]:50795 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab3KDSms (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Nov 2013 13:42:48 -0500
Received: by mail-qe0-f50.google.com with SMTP id 1so4356607qee.37
        for <linux-wireless@vger.kernel.org>; Mon, 04 Nov 2013 10:42:47 -0800 (PST)
MIME-Version: 1.0
Reply-To: zaphod@berentweb.com
In-Reply-To: <1383581905.17589.0.camel@dcbw.foobar.com>
References: <CAPSTskvByfGWTyDmq9WeX7Em1N0DAAZ3eKDV5eV6qfkH2gDzdA@mail.gmail.com>
	<1383581905.17589.0.camel@dcbw.foobar.com>
Date: Mon, 4 Nov 2013 20:42:47 +0200
Message-ID: <CAPSTskvZALnaNYfBxCx_fFhYuTPW8AOVkyN9DTBeErfO67hQBw@mail.gmail.com> (sfid-20131104_194252_999427_D9669617)
Subject: Re: orinoco (Lucent/Agere 9.48) unable to connect
From: Beeblebrox <zaphod@berentweb.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> What kind of access point are you trying to connect to?  These devices
> only support 802.11b, so if the access point is newer and is using
> 802.11n, there are some 11n configurations that simply don't support
> connections from 11b clients.
> Dan

Hi Dan, thanks for your answer.
The test A/P is a USR-5451-maxG with ddwrt as OS. A/P is on mixed mode
(B+G), but after your mail I tried B-Only mode, which failed also.
While observing the connection process, I got the feeling that the
orinoco card (eth1) is unable to set an IP. I have tried static and
dhclient, with same effect. Shortly after the connection process
starts, the card status shows as connected, but does not finalize .
Process then terminates (assuming because no IP is agreed on with AP).

Please advise what other info/test I can try.
Regards.
