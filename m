Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:40760 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757361AbYKTOtg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 09:49:36 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: Fwd: p54: testing AP mode: cannot switch to master mode
Date: Thu, 20 Nov 2008 15:49:12 +0100
Cc: "Stefan Steuerwald" <salsasepp@googlemail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
References: <f76a32050811190306s6a86f46dwc245200069ff8a82@mail.gmail.com> <f76a32050811200050u48bc150en34e94c7671672ae6@mail.gmail.com> <f76a32050811200544p3c647cb3t392025feef02c8f9@mail.gmail.com>
In-Reply-To: <f76a32050811200544p3c647cb3t392025feef02c8f9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200811201549.13078.hs4233@mail.mn-solutions.de> (sfid-20081120_154955_831205_3F660406)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some comments about 
your "ipod_http_request_probe_responses.pcap":

I think here the same problem happens.

In packet 10 and again in packet 12 your Ipod tells the AP that 
it is now sleeping. The AP acknowledges both packets.

Then I see lots of probe responses from the AP to a different 
MAC, but they seem to be unrelated to your Ipod. Also the probe 
requests that one can see are from somebody else, e.g.

In packet 121 your Ipod tells the AP that it now woke up and 
immediately closed the HTTP connection.



And you might have guess by now that also in 
your "ipod_http_request_tcp_reset.pcap" the problem started once 
your Ipod told the AP that it goes to sleep, again with two 
packets.
