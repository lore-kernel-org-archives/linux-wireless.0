Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56976 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752871AbYFJPcd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2008 11:32:33 -0400
Message-ID: <484E9F12.9010502@gmx.de> (sfid-20080610_173237_004587_B2C15A3F)
Date: Tue, 10 Jun 2008 17:34:42 +0200
From: Joe <wirelesss@gmx.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: [english 95%] QUESTIONS to ieee80211_beacon_get AND ieee80211_get_buffered_bc
References: <4848289D.1080205@mandriva.org> <1ba2fa240806051103q652accf5t1bd1d94630ebea5b@mail.gmail.com> <48482BC3.4070402@mandriva.org> <4848482C.2080208@mandriva.org> <48485F12.2050908@mandriva.org> <484E9436.605@gmx.de>
In-Reply-To: <484E9436.605@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes,

thanks to your helpfull support, which enabled me to precise my request, 
which I edited in the follows:
> Hy all,
>
> I have a question to he two methods:
>
> ieee80211_beacon_get
> ieee80211_get_buffered_bc
> in tx.c
>
> Both are called by the hardware driver to get a current beacon from 
> the ieee80211 stack. Thereby the ieee80211_beacon_get is called 
> normally. The other method is just called, if a buffered /multicast 
> channel(DTIM) is needed or used - but necessaryly the 
> ieee80211_beacon_get must be called before. Is this right?
> So if I want to manipulate the beacons send out I would start at 
> ieee80211_beacon_get right?
>
> How often refresh the hardwaredriver usually the requested beacon? 
> Does "Returned skb is used only once and low-level driver is 
> responsible of freeing it." means, that the method is called always 
> when new Beacon frame will be transmitted? Or does this depend on the 
> hardware?
> Which kind of hardwaredrivers does allready utilize this methods, isit 
> allready the standard way to transfer the generation of the beacons to 
> the stack?
>
> An total independent question: Following the suggestion of Holger 
> Schurig I started to extend the Glossary in the wiki (with the 
> abbreviations in the source code) a few hours ago, but My extension 
> was removed again. Why?
>
> All the Best
> Sebastian
