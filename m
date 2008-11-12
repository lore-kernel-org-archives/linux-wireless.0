Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:38628 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbYKLLER (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 06:04:17 -0500
From: Michael Buesch <mb@bu3sch.de>
To: EforeZZ <EforeZZ@gmail.com>
Subject: Re: broadcom driver
Date: Wed, 12 Nov 2008 12:03:55 +0100
Cc: linux-wireless@vger.kernel.org
References: <cc2a6eec0811120248q1a0850deg390aec1549700cd0@mail.gmail.com>
In-Reply-To: <cc2a6eec0811120248q1a0850deg390aec1549700cd0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200811121203.55747.mb@bu3sch.de> (sfid-20081112_120422_910273_6DA80392)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 12 November 2008 11:48:04 EforeZZ wrote:
> Hi guys,
> 
> We're trying to write a broadcom WiFi driver for FreeBSD.
> We looked at M$ Windows driver and found these structures..
> We'd be very grateful if anyone tells the standard and/or description
> of what these values may mean..
> 
> struct _locale_info_t
> {
>    unsigned char   valid_channels[28];
>    struct radar_channels;
>    struct restricted_channels;
>    unsigned char   maxpwr[6];
>    unsigned char   pub_maxpwr[5];
>    unsigned char   flags;
> };

Hm, it's pretty obvious what this is. Just read it.
It's channel tables for different locales. Not very interesting stuff.

Anyway, you should probably contact Dragonfly people. They are already
writing a BSD licensed driver.

-- 
Greetings Michael.
