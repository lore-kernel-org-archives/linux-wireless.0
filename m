Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:50140 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbYJYK6r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2008 06:58:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexey Fisher <bug-track@fisher-privat.net>
Subject: Re: why differnet wlan drivers need different settings?
Date: Sat, 25 Oct 2008 13:03:34 +0200
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
	linux-wireless@vger.kernel.org
References: <200810251153.25533.bug-track@fisher-privat.net>
In-Reply-To: <200810251153.25533.bug-track@fisher-privat.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200810251303.35295.rjw@sisk.pl> (sfid-20081025_125851_941986_A35600E6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday, 25 of October 2008, Alexey Fisher wrote:
> May be this is the wrong plase to ask. 

Yeah, better ask that on linux-wireless@vger.kernel.org (CCed).

> The question is: Why differnet wlan drivers use different settings to stay 
> silent - powered on but not trying to associate to any accespoint?
> For example: ipw2200 - if wlan was connfigured like:
> 
> iwconfig wlan1 essid "my-ap" chan 6 ap my:aps:mac ?key s:pass
> 
> this will normaly connect to my secure ?AP. and if i set after this:
> ?
> iwconfig wlan1 essid off ap off
> 
> it will connect to unsecure AP of my neighbour or of Dr.Evil :)
> to disable association on ipw2200 i need to set all this and plus "chan 0".
> With this cnowleg i want to set up iwl3945, and surprise it's not working. 
> This driver do not accepted "chan 0" and instead of "essid off" it did 
> "essid """
> 
> Are there any unified way to keep adapter powered on but not trying to 
> associate to some AP?
> 
