Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelay.embarq.synacor.com ([208.47.184.3]:37030 "EHLO
	mailrelay.embarq.synacor.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752125Ab1FUXYj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 19:24:39 -0400
Message-ID: <025938ff6a6ed7f2d8bfa7b80af70b86.squirrel@mail.errtech.com> (sfid-20110622_012525_748666_96F81AAA)
Date: Tue, 21 Jun 2011 19:24:38 -0400
Subject: linux-wireless@vger.kernel.org
From: "chris" <tmail133@kglug.org>
To: linux-wireless@vger.kernel.org
Reply-To: tmail133@kglug.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying to get a system with an Intel Atom N270 cpu and the Intel
945GSE chipset working with a wifi card with a ar9170. We've used these
cards on dozens of different systems with different routers without too
many problems thus far. We would like to use them on thousands (maybe
15-20k) although so far have been unable to get it working on the
device/router we want to use it with.

Here are some of the logs of the device with the problem:

10.04.2

http://errtech.com/ar9170/1004.txt

11.04

http://errtech.com/ar9170/1104.txt

iwconfig shows 13mbps with 11.04 and it looks like the carl9170
driver/firmware. And maybe 5mbps with 10.04.2.

We have had a ralink device show in the hundreds.

Is there anything obviously wrong here? I wasn't able to pick anything
out. These are basically default Ubuntu installs without any
configuration.


