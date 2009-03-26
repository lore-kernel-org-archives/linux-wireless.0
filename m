Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.sdinet.de ([78.47.32.153]:39002 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759828AbZCZRFV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 13:05:21 -0400
Date: Thu, 26 Mar 2009 17:55:43 +0100 (CET)
From: Sven-Haegar Koch <haegar@sdinet.de>
To: Paco <eyes2k5@gmail.com>
cc: linux-wireless@vger.kernel.org
Subject: Re: Driver Support Linux 2.4.26 zd1211
In-Reply-To: <b49006ab0903260822r35417242qbdc6889543de7072@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0903261752470.11410@aurora.sdinet.de> (sfid-20090326_180526_354568_C1D96594)
References: <b49006ab0903260414xad13bd5y370a47020348c66f@mail.gmail.com> <b49006ab0903260822r35417242qbdc6889543de7072@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 26 Mar 2009, Paco wrote:

> Hello everybody, and sorry if I disturb you with something that was
> fixed before.
> 
> I'm trying to setup the zd1211 in Linux 2.4.26-ts11 in the board
> TS-7200. I have some drivers that are working only with networks
> without encryption. If I try to connect to a network with WEP or WPA
> encryption, i can not get the access point. I am looking for a new
> version of drivers to solve this problem.

I think for 2.4.x: forget it.

For 2.6.26 it may be possible using compat-wireless-old, or just using a 
more current kernel 2.6.27+, perhaps with compat-wireless to get the 
latest version.

c'ya
sven

-- 
The lights are fading out, once more...
