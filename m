Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:57177 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbYDEAmi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 20:42:38 -0400
From: Chr <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 5/5] p54: update Makefile and Kconfig
Date: Sat, 5 Apr 2008 02:42:35 +0200
Cc: mcgrof@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, flamingice@sourmilk.net
References: <E1Jhv2j-0006LQ-3j@debian64.daheim> <200804050219.32270.chunkeey@web.de> <1207355167.6675.9.camel@johannes.berg>
In-Reply-To: <1207355167.6675.9.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200804050242.36018.chunkeey@web.de> (sfid-20080405_014241_947653_16D60693)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 05 April 2008 02:26:07 Johannes Berg wrote:
> > John? can you please do the git mv?
> > I have attached a diff to make checkpatch.pl happy, so you don't have to
> > do it. ;-)
>
> Uh, I think you need at least a small patch that modifies the
> drivers/net/wireless/{Makefile,Kconfig} as appropriate. From what I
> could see, your original patch didn't even add the wireless/p54/Kconfig
> into wireless/Kconfig so it wouldn't be useful?
>

hmmmmm, look careful! one small + ;-) it's nearly invisible.

+source "drivers/net/wireless/p54/Kconfig" 

Regards,
	Chr

