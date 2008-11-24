Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:5180 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbYKXIZV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 03:25:21 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: ath5k: problems during the connection to a sitecom AP
Date: Mon, 24 Nov 2008 09:25:13 +0100
Cc: "Bob Copeland" <me@bobcopeland.com>,
	"Fabio Rossi" <rossi.f@inwind.it>
References: <200811150207.12084.rossi.f@inwind.it> <200811192315.35537.rossi.f@inwind.it> <b6c5339f0811211222t745c65fve38958c9baa98e46@mail.gmail.com>
In-Reply-To: <b6c5339f0811211222t745c65fve38958c9baa98e46@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200811240925.13996.hs4233@mail.mn-solutions.de> (sfid-20081124_092525_640864_3367FA00)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 21 November 2008 21:22:41 Bob Copeland wrote:
>    # tcpdump -s 1000 -w assoc.cap -i wlan1
>
> Then you can load assoc.cap into wireshark (you can capture
> from inside wireshark too if you prefer).

Or dump tcpdump completely, because you can make a dump from the 
commandline with text-based wireshark "tshark":

tshark -s 1000 -i wlan1 -w assoc.cap


(However, I usually omit the -s 1000 when using tshark)
