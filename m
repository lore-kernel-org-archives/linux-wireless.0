Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm32-vm2.bullet.mail.bf1.yahoo.com ([72.30.239.138]:41258 "HELO
	nm32-vm2.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751636Ab2BRMPb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Feb 2012 07:15:31 -0500
Message-ID: <1329567329.52125.YahooMailClassic@web161605.mail.bf1.yahoo.com> (sfid-20120218_131600_102350_081CC350)
Date: Sat, 18 Feb 2012 04:15:29 -0800 (PST)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: [rt2x00] rt2800usb and RT3070 issues with 54G AP
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <20120216125522.GF25833@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oh, forgot the mention - the results are with the latest CW.

> -0800, Walter Goldens wrote:
> > My rt3070 USB card works flawlessly when connected to
> an 802.11N AP. Excellent throughput, speed and reliability.
> > 
> > When connected to a 54G AP however, there is
> significant packet loss and duplicates.
> > I can confirm this to be happening with two older 54G
> APs, and not with a single N AP.
> >
> > Does anyone else have the same problem?
> 
> Usually we have opposite problem, 11g works, 11n does not.
> 
> Are you using the lates wireless-testing tree? If not, try
> that
> i.e using compat-wireless package there are some pending
> radio chip
> programing fixes, I think they may help with packet lost.
> 
> Stanislaw   
> 
