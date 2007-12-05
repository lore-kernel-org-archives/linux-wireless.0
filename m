Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:22415 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbXLEHta (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 02:49:30 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [RFC][PATCH] mac80211: Use PID controller for TX rate control
Date: Wed, 5 Dec 2007 08:49:46 +0100
Cc: "Nick Kossifidis" <mickflemm@gmail.com>,
	"Stefano Brivio" <stefano.brivio@polimi.it>,
	"Mattias Nissler" <mattias.nissler@gmx.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
References: <1196622331.7472.4.camel@localhost> <20071204024146.15689ee3@morte> <40f31dec0712041405sb14243dw9ccb7509e6f58d8@mail.gmail.com>
In-Reply-To: <40f31dec0712041405sb14243dw9ccb7509e6f58d8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200712050849.46760.hs4233@mail.mn-solutions.de> (sfid-20071205_074941_123573_FC7B4EA3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 04 December 2007 23:05:28 Nick Kossifidis wrote:
> [  3]  0.0-60.0 sec  29.4 MBytes  4.11 Mbits/sec  3.242 ms
> [  3]  0.0-60.0 sec  29.4 MBytes  4.11 Mbits/sec  4.439 ms
> [  3]  0.0-60.0 sec  32.7 MBytes  4.57 Mbits/sec
...


Could it be the case that if we test the PID controller such way,
then we optimize for throughtput in a scenario like "laptop sits 
next the the AP".

Or, in other words: if we put the AP 80m away and then try the 
test, would the same PID parameters that yielded high MB/s rates 
now still keep us a sane (for that distance!) connection?
