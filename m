Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:42499 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966Ab3GaJ2u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 05:28:50 -0400
Received: by mail-ee0-f49.google.com with SMTP id d41so225042eek.8
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jul 2013 02:28:49 -0700 (PDT)
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: AP changed bandwidth, new config is  ... changed bandwidth in a way we can't support - disconnect - why? (intel advanced-n 6250)
Date: Wed, 31 Jul 2013 11:28:46 +0200
Cc: Andy Isaacson <adi@hexapodia.org>, linux-wireless@vger.kernel.org,
	ilw@linux.intel.com
References: <201307310855.28080.a.miskiewicz@gmail.com> <1375260632.8289.10.camel@jlt4.sipsolutions.net>
In-Reply-To: <1375260632.8289.10.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201307311128.47064.a.miskiewicz@gmail.com> (sfid-20130731_112853_556594_1C2C86A1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 31 of July 2013, Johannes Berg wrote:
> On Wed, 2013-07-31 at 08:55 +0200, Arkadiusz Miskiewicz wrote:
> > It basically reports:
> > [79477.496067] eth1: AP 68:7f:74:06:b3:1b changed bandwidth, new config
> > is 2422 MHz, width 1 (2422/0 MHz) [79477.496072] eth1: AP
> > 68:7f:74:06:b3:1b changed bandwidth in a way we can't support -
> > disconnect
> > 
> > (note I have two wrt160nl here and problem happens with both)
> > 
> > Any hints on why "we can't support" configuration issued by this (common)
> > AP?
> 
> As far as I can tell, it seems to be an AP bug, but I had no idea this
> was so common.
> 
> Testing with hostapd, I can switch bandwidth between 20 and 40 MHz just
> fine, and it only prints "new config is ..." and then carries on.
> 
> Since you seem to be able to reproduce this easily, can you run tcpdump
> with the beacon info?

Will do. Unfortunately the problem doesn't always happen. Sometimes things 
work fine with this AP, sometimes they don't (and right now can't reproduce, 
so waiting for thing to happen again).

btw. full dmesg
http://pastebin.com/zTfR5rTK

> johannes


-- 
Arkadiusz Miśkiewicz, arekm / maven.pl
