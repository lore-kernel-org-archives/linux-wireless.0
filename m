Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost01.isp.att.net ([207.115.11.51]:58513 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbZFGNQH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 09:16:07 -0400
Message-ID: <4A2BBD98.4040708@lwfinger.net>
Date: Sun, 07 Jun 2009 08:16:08 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Markus <sparcoular@t-online.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: bcm43xx 5.10.38.35 firmware
References: <loom.20090607T124008-575@post.gmane.org>
In-Reply-To: <loom.20090607T124008-575@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Markus wrote:
> Hello,
> 
> 
> after MacOSX Airport firmware update 5.10.38.35
> 
> (bcm43xx/ Macbook Core2Duo SR)
> 
> I cannot connect to my Wlan-Router anymore.
> 
> 
> The b43-module gets modprobed without errors
> 
> and nm-applet shows my Access-Points SSID.
> 
> Alas, it won't establish a connection to it.
> 
> 
> Any clues?

Please post all items in dmesg that pertain to ssb or b43 using

dmesg | egrep "ssb|b43"


Larry
