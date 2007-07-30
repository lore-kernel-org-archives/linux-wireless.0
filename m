Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from a83-132-36-246.cpe.netcabo.pt ([83.132.36.246]:42249 "EHLO
	taurus.digitalself.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751395AbXG3MlX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2007 08:41:23 -0400
Subject: Re: Linux wireless stack question
From: Alfredo Matos <alfredo.matos@digitalself.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: maali Al Janoob <mms82@hotmail.com>, tomasw@gmail.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1185795198.4006.89.camel@johannes.berg>
References: <BAY111-F325FAED32F3D133BCD0C69B6ED0@phx.gbl>
	 <1185795198.4006.89.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 30 Jul 2007 13:08:30 +0100
Message-Id: <1185797310.12159.2.camel@pegasus>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-07-30 at 13:33 +0200, Johannes Berg wrote:
> On Sun, 2007-07-29 at 18:21 +0400, maali Al Janoob wrote:
> 
> > What I want to do basically is changing the backoff algorithm to implement a 
> > modified protocol in Linux (for my thesis). From what I know, the firmware 
> > is inaccessible. Are you aware of any available source code for a firmware 
> > of any driver?
> 
> Nope, none freely available. There are some efforts (prism54, bcm43xx)
> to write free firmware for some devices, but none of them are in a stage
> that could be used. (prism54: dunno, but I know it's not usable;
> bcm43xx: only partially reverse engineered)
> 

What about atheros dadwifi [1] and openHAL [2] ? Could this help ?

Alfredo.

[1] - http://madwifi.org/wiki/DadWifi
[2] - http://madwifi.org/wiki/OpenHAL

