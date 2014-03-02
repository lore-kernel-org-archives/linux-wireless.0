Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:57753 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaCBHux (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Mar 2014 02:50:53 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21266.58035.719712.344551@gargle.gargle.HOWL> (sfid-20140302_085122_900813_74D02304)
Date: Sun, 2 Mar 2014 13:20:11 +0530
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	"ath9k-devel\@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH 00/23] ath9k|ath9k_htc: move dups to common-beacon
In-Reply-To: <5312DD46.3030800@rempel-privat.de>
References: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
	<21266.37896.937680.416439@gargle.gargle.HOWL>
	<5312DD46.3030800@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oleksij Rempel wrote:
> I was thinking about it too, but suddenly i don't have enough time and
> experience to do it. Beside, there is no need to write usb layer. It is
> clean and separate from other part of the driver. But the HTC/WMI
> interface is not completely separate.

Sure. It is just another option to consider.

> Now about bigger picture. Right now i work only on ath9k<>ath9k_htc
> dups. But there are lots of dup code in ath9k itself. For example
> *_phy.c, *_initvals.h. Here are some examples:

We already have duplicate detection for initvals. It is part of
the initvals tool in qca-swiss-army-knife.

Sujith
