Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:56158 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab3LAAcB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Nov 2013 19:32:01 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21146.33378.141904.187743@gargle.gargle.HOWL> (sfid-20131201_013207_556526_9C6CF954)
Date: Sun, 1 Dec 2013 05:57:14 +0530
To: Drasko DRASKOVIC <drasko.draskovic@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"hostap\@lists.shmoo.com" <hostap@lists.shmoo.com>, j@w1.fi
Subject: Re: multi-wiphy (virtual radios that can be used with multiple channels)
In-Reply-To: <CAEk6gTCqKgt9zX0Xs147GYfxDw2Ex-1NkG4KZ_m_pdf1M8eDLw@mail.gmail.com>
References: <CAEk6gTCqKgt9zX0Xs147GYfxDw2Ex-1NkG4KZ_m_pdf1M8eDLw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drasko DRASKOVIC wrote:
> Hi all,
> can somebody please explain in some more details this possibility of
> ath9k driver, mentioned here: http://lwn.net/Articles/321690/ and
> specially here:
> http://osdir.com/ml/linux-wireless/2009-03/msg00090.html in these
> patches signed-off by Jouni.

The virtual wiphy feature has been removed from ath9k.

> Does this means that ath9k devices can be put in AP and STA modes
> simultaneously (one virtual interface for each) over different
> channels?
> 
> I am looking to solve this problem: I want to have always present AP
> for user settings that I bring on boot, so I give it some
> pre-configured channel. Via this AP user will configure other
> interface in STA mode to connect to home network. However, this home
> network can be over any channel, very potentially different of the one
> I have chosen for AP.

Multi Channel Concurrency is required to do this, but ath9k doesn't
support it right now.

Sujith
