Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:26351 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724AbZJRSlf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Oct 2009 14:41:35 -0400
Received: by ey-out-2122.google.com with SMTP id 9so782472eyd.19
        for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2009 11:41:38 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: jack craig <jackc@linuxlighthouse.com>
Subject: Re: moblin, rt2860, and unhappiness
Date: Sun, 18 Oct 2009 20:41:36 +0200
Cc: linux-wireless@vger.kernel.org
References: <4ADB5334.3070109@linuxlighthouse.com>
In-Reply-To: <4ADB5334.3070109@linuxlighthouse.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200910182041.36795.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> i figure my best case is to find a way to get the ralink driver working with the moblin os,
> but at least one person has failed at that attempt to far.
> 
> a fall back position is to go with a fedora os where i could get the driver working there
> (if it doesn't already).
> 
> so, finally, my query to this august group; given this sob story, what is your wisdom on the topic?

The rt2800pci driver has recently been merged into wireless-testing git tree, that driver isn't working
perfectly yet, but that is the driver where all development effort should go into.

You can find the rt2800pci driver in the
drivers/net/wireless/rt2x00 folder.

> is my goal to get the rt2860 working on moblin a gesture in futility?

Absolutely not. :)

> does it make sense to bail and go on to FC? i use FC for my desktop and work so i prefer it over ubuntu ,...

This is not a distribution problem, but simply a lack of a good driver in the kernel itself.

Ivo
