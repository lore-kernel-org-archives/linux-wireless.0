Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:53105 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965AbYEQOvt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2008 10:51:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: rt61pci breaks after hibernate
Date: Sat, 17 May 2008 16:51:56 +0200
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <g0mqn8$56h$1@ger.gmane.org>
In-Reply-To: <g0mqn8$56h$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200805171651.56973.rjw@sisk.pl> (sfid-20080517_165152_599514_437FC760)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday, 17 of May 2008, Sitsofe Wheeler wrote:
> After resuming from a hibernate to disk network packets are no longer sent
> and NetworkManager shows that there is no signal. Doing ifconfig wlan1
> down && ifconfig wlan1 up results in the error message "SIOCSIFFLAGS: No 
> such device" being printed.

Is this a regression or did it work before?

Rafael
