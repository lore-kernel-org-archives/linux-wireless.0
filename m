Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:35048 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752464AbZAaQ3I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jan 2009 11:29:08 -0500
Message-ID: <49847C47.50709@lwfinger.net> (sfid-20090131_172913_462710_CA51949D)
Date: Sat, 31 Jan 2009 10:28:55 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Danny Kukawka <dkukawka@suse.de>
CC: linux-wireless@vger.kernel.org, Helmut Schaa <hschaa@suse.de>
Subject: Re: [PATCH 2/4] b43legacy: fix led naming
References: <200901311552.16582.dkukawka@suse.de>
In-Reply-To: <200901311552.16582.dkukawka@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Danny Kukawka wrote:
> From: Danny Kukawka <dkukawka@suse.de>
> Subject: b43legacy: fix led naming
> 
> Fixed led device naming for the b43legacy driver. Due to the
> documentation of the led subsystem/class the naming should be
> "devicename:colour:function" while not applying sections
> should be left blank.
>     
> This should lead to e.g. "b43legacy-%s::rx" instead of 
> "b43legacy-%s:rx".
> 
> Signed-off-by: Danny Kukawka <dkukawka@suse.de>
> --
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
