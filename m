Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55416 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751334AbYFJOqM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2008 10:46:12 -0400
Message-ID: <484E9436.605@gmx.de> (sfid-20080610_165400_911481_E6BDBEC3)
Date: Tue, 10 Jun 2008 16:48:22 +0200
From: Joe <wirelesss@gmx.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: QUESTIONS to ieee80211_beacon_get AND ieee80211_get_buffered_bc
References: <4848289D.1080205@mandriva.org> <1ba2fa240806051103q652accf5t1bd1d94630ebea5b@mail.gmail.com> <48482BC3.4070402@mandriva.org> <4848482C.2080208@mandriva.org> <48485F12.2050908@mandriva.org>
In-Reply-To: <48485F12.2050908@mandriva.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hy all,

I have a question to he two methods:
 
 ieee80211_beacon_get
 ieee80211_get_buffered_bc
 in tx.c

Both are called by the hardware to get the current beacon from the 
ieee80211 stack, right?
So if I want to manipulate the beacons send out I would start at this 
point right?

But where is the difference inbetween is it depending on the 
hardwaredriver, which method is called?

How often refresh the hardwaredriver usually the requested beacon ? Per 
transmission or only once for ther activity duration?
Which kind of hardwaredrivers does allready utilize this methods, isit 
allready the standard way to transfer the generation of the beacons to 
the stack?

An total independent question: Following the suggestion of Holger 
Schurig I started to extend the Glossary in the wiki (with the 
abbreviations in the source code) a few hours ago, but My extension was 
removed again. Why?

All the Best
Sebastian

