Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gate.linuxlighthouse.com ([63.249.90.144]:40315 "EHLO
	linuxlighthouse.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952AbZJRSAt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Oct 2009 14:00:49 -0400
Received: from ws.linuxlighthouse.com (ws.linuxlighthouse.com [192.168.2.20])
	(authenticated bits=0)
	by linuxlighthouse.com (8.14.3/8.14.3) with ESMTP id n9IHf8uJ031813
	for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2009 10:41:08 -0700
Message-ID: <4ADB5334.3070109@linuxlighthouse.com>
Date: Sun, 18 Oct 2009 10:41:08 -0700
From: jack craig <jackc@linuxlighthouse.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: moblin, rt2860, and unhappiness
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi linux-wireless,

This is my first posting, so please pardon me if I break any rule.

A bit a background, last spring in a bout of unemployment, i wanted to find a new development direction.

i had been working with a company providing wireless products (Danger), and wanted to continue that
direction using  mobile linux as a platform.

I subscribed to the moblin developers list, bought an Asus EeePC 1000 with xandros installed and began
my development project.

I chose to keep the xandros os in the netbook as its wireless was the first working wireless
i've had. i booted the various moblin pre-beta releases via the thumbdrive and wasnt too
worried when the wireless didnt work on the moblin os; after all it was pre-beta.

as the xandros wireless worked, i felt confident that the good folks at Intel would make my netbook
wireless work by the time beta rolled around.

it was my error in assuming an Intel cpu included a Intel wireless chipset, instead i found i had an rt2860.

as beta came and went with still no wireless joy, i started probing deeper and found the ralink
rt2860 support wasnt going to be covered in the moblin project work.

so here i am with a netbook that cant get to the net with the os of my choice. Much unhappiness!

i have learned that the driver source is available and i plan to track that down.

i have also been toying with the idea of surgery; putting a Intel wireless chipset in the eeepc,
but the only article I've found on that topic is a bit much for a software only geek.

I like the eeepc and want to use it with wireless.

i figure my best case is to find a way to get the ralink driver working with the moblin os,
but at least one person has failed at that attempt to far.

a fall back position is to go with a fedora os where i could get the driver working there
(if it doesn't already).

so, finally, my query to this august group; given this sob story, what is your wisdom on the topic?

is my goal to get the rt2860 working on moblin a gesture in futility?

does it make sense to bail and go on to FC? i use FC for my desktop and work so i prefer it over ubuntu ,...

Suggestions? tia, jackc...

-- 
    jack craig
       jackc@LinuxLightHouse.com
          831-684-1375 (Office)
             831-596-6924 (cell)
                IM: jackcraigaptos (AIM)
_________________________________
This email has been ClamScanned !
     www.LinuxLightHouse.com
