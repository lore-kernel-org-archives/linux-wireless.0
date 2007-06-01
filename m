Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:53756 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761887AbXFATY4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2007 15:24:56 -0400
Message-ID: <46607281.4060802@lwfinger.net>
Date: Fri, 01 Jun 2007 14:24:49 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: "John H." <mistamaila@gmail.com>
CC: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Upgrade to f7 breaks bcm43xx module
References: <5b9417770706011111u20f32192s960961dc8693f00e@mail.gmail.com>	 <4660630E.7040701@lwfinger.net>	 <5b9417770706011123s3a54c43ep69257321e8102719@mail.gmail.com>	 <5b9417770706011137q59962e95y6d810b236e6c0c3a@mail.gmail.com> <5b9417770706011155q50519ecftd3e4b8114102664f@mail.gmail.com>
In-Reply-To: <5b9417770706011155q50519ecftd3e4b8114102664f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John H. wrote:
> Sorry, I got it all fixed.  The XP installation on my system had the
> file.  There is a warning that says
> 
> Warning! Idle-TSSI.... Disabling TX power adjustment.
> 
> But I assume it's nothing?  Hopefully this doesn't have the speed
> problems that required a patch before.

It is not 'nothing', but there is no known fix. With the bcm43xx-mac80211 driver, I can use only a 
rate of 1 Mbs. Others do better, but there are no patches.

If you want a bcm43xx kernel that doesn't require patching, you need 2.6.22-rc3.

Larry

