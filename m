Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.236]:54275 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbYJ1Fsb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 01:48:31 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2529561rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Oct 2008 22:48:31 -0700 (PDT)
Message-ID: <a32f33a40810272248j5ee755ccoc8f6a8c8d5338cb8@mail.gmail.com> (sfid-20081028_064836_284897_A98123CF)
Date: Tue, 28 Oct 2008 06:48:31 +0100
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: rtl2860 driver in mainline?
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <20081028004915.GA3442@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081028004915.GA3442@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> So, on my quest to suck up every out-of-tree driver and get it into the
> main kernel tree (drivers/staging/ to start with), I've been pointed at
> the rtl2860 driver.

in that case make sure you include rt2870 on your list as well then. ;)

> Does anyone know of a "cleaned up" version of this driver that is
> newer/better than the one on ralink's web site?  I found the
> 2008_0918_RT2860_Linux_STA_v1.8.0.0.tar.bz2 version there, and will
> start with that if no one else has yet.

rt2800pci/rt2800usb development is in progress in the rt2x00.git
experimental branch:
http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=shortlog;h=experimental

The current status is that rt2800usb has working RX with some warnings
regarding the
RX signal, and a non functional TX. rt2800pci isn't complete yet.

So far progress has been very slow because of lack of time, so any help with the
development of the drivers is welcome.

Ivo
