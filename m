Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:54690 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbZGRKMJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jul 2009 06:12:09 -0400
Subject: Re: Setting rfkill from user space
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: tim.gardner@canonical.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1247911044.1055.22.camel@johannes.local>
References: <4A60E5EC.1080700@canonical.com>
	 <1247911044.1055.22.camel@johannes.local>
Content-Type: text/plain
Date: Sat, 18 Jul 2009 12:11:47 +0200
Message-Id: <1247911907.4549.77.camel@violet>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > Because the rfkill sysfs info moved around, I've been working on a
> > program for the Debian acpi-support package that can be used to perform
> > 2 operations; 1) discover if there are any wireless devices powered on,
> > and 2) toggle the states of all wireless devices (at the same time).
> > 
> > git://kernel.ubuntu.com/rtg/rfkill
> 
> Oh, I'm sorry, we already had http://git.sipsolutions.net/rfkill.git/, I
> really should have publicised that more (and wasn't around when you
> asked the question yesterday).

I saw this post yesterday, but didn't realize they wrote their own tool.

Regards

Marcel


