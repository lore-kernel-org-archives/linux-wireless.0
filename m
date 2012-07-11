Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:42546 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755390Ab2GKOgd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 10:36:33 -0400
Message-ID: <4FFD8F6F.7030100@net.t-labs.tu-berlin.de> (sfid-20120711_163636_818668_CC068754)
Date: Wed, 11 Jul 2012 16:36:31 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: DINO MYCLE <dino.mycle@sasken.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Per packet TPC is it implimented ?
References: <28DA1CA8CF17234FB030B1ECF787E6B7B9339AD6D4@EXGMBX01.sasken.com> <4FFD63C0.6080002@net.t-labs.tu-berlin.de> <28DA1CA8CF17234FB030B1ECF787E6B7B9339AD7A0@EXGMBX01.sasken.com> <4FFD7646.9060404@net.t-labs.tu-berlin.de> <28DA1CA8CF17234FB030B1ECF787E6B7B9339AD7AC@EXGMBX01.sasken.com>
In-Reply-To: <28DA1CA8CF17234FB030B1ECF787E6B7B9339AD7AC@EXGMBX01.sasken.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



DINO MYCLE schrieb:

> Hello Thomas,
>   Sorry, got it....so how is the performance any report or observation you can share ?
> 


Our initial results (including mac80211 & TPC controller design, with
validations) are published at the ICCCN conference end of July within
our paper: "Practical Power and Rate Control for WiFi"

in short:
- TPC per packet on Atheros 802.11 g/a/n chips works well
- without giving up on throughput there are often cases to reduce
transmit power by significant amount of dB
- to show increased spatial reuse in a WLAN network is current work

The pdf should be online soon at:
http://www.inet.tu-berlin.de/menue/research/publications/by_author/thomas_publ/

Currently we are running performance measurements (network sum
throughput) in outdoor and indoor environments with our joint power-rate
controller "Minstrel-Blues". Collecting, parsing, plotting
traces is just ongoing work.

Greetings Thomas
