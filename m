Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout7.parasun.com ([204.174.16.217]:51484 "EHLO
	mailout7.parasun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757480AbXLRQGp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 11:06:45 -0500
Date: Tue, 18 Dec 2007 10:06:13 -0600 (CST)
From: Jeff Williams <angelbane@ou.edu>
To: Mark Williamson <mark.williamson@imperial.ac.uk>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Queries about acx-mac80211 master mode support on the AR7 platform
In-Reply-To: <4767E141.7080801@imperial.ac.uk>
Message-ID: <Pine.LNX.4.64.0712180958060.12930@dulcinea> (sfid-20071218_160649_953854_98391B60)
References: <4767E141.7080801@imperial.ac.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Tue, 18 Dec 2007, Mark Williamson wrote:

> Hi,
Hi Mark,

>
> Hence to address this, initial work was taken for the acx driver to
> utilise the mac80211 stack and a new acx driver called acx-mac80211 was
> written (http://acx100.sourceforge.net/wiki/Acx-mac80211).  IMHO this
> still very much WIP and is nowhere near as stable as the original acx
> driver. But, perhaps the largest sticking point is that the acx-mac80211
> driver, unlike acx, does not support AP (master) mode. I have struggled
> to find out whether this is an issue in the acx-mac80211 driver
> component or in fact the mac80211 does not support master mode at this
> moment in time. Can anyone shed some light on this and help clear up my
> ongoing confusion?

I'm the guy who started the acx-softmac to acx-mac80211 conversion, and my 
intention was to provide ap support for the card, but I've had other 
projects come up demanding my attention. So I apologize for its WIP state.

I'll have to defer to those working on nl80211/lib80211 and hostapd to 
answer whether mac80211 actually supports AP mode, I recall a comment 
about b43/legacy being the only driver to actively support Master?

Anyway, I spoke with a guy who was interested in continuing work on the 
acx-mac80211 a couple of months back, he seemed eager but I've not heard 
anything from him since.

I'm sorry I couldn't help you more,
Jeff
