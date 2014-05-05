Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42105 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbaEETXE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2014 15:23:04 -0400
Message-ID: <1399317771.22235.23.camel@jlt4.sipsolutions.net> (sfid-20140505_212309_163503_2C94BE06)
Subject: Re: How to configure monitor devices for HT80?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 05 May 2014 21:22:51 +0200
In-Reply-To: <5367E13C.2020208@candelatech.com> (sfid-20140505_211155_884363_141E505C)
References: <5367E13C.2020208@candelatech.com>
	 (sfid-20140505_211155_884363_141E505C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-05-05 at 12:06 -0700, Ben Greear wrote:
> I'm trying to sniff using a monitor interface on ath10k, on channel 36.
> 
> I'm seeing lots of packets, but not all that the AP claims to be sending
> (when sniffing vap0).  I am not not certain the monitor interface is
> using HT80 or not.
> 
> Anyone have a working example of the proper iw commands to create
> a monitor interface on channel 36 for HT80?

...
iw wlan0 set freq 5180 80 5210

johannes

