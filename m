Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:27890 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbXK2JTg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2007 04:19:36 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [BUG] libertas: probing for Marvell USB8388 fails
Date: Thu, 29 Nov 2007 10:20:31 +0100
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	Dan Williams <dcbw@redhat.com>
References: <20071117023548.79a7a33c@morte> <1195502746.6479.11.camel@localhost.localdomain> <20071119213123.084d40f7@morte>
In-Reply-To: <20071119213123.084d40f7@morte>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711291020.31946.hs4233@mail.mn-solutions.de> (sfid-20071129_091952_780110_763E8086)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Which branch of wireless-2.6 are you running?  What kernel
> > version?
>
> Branch everything, head:
> 1efded8eb6a7554748ca9486a9902fa6e86ff4a7.

I can't find this.

$ git clone --reference /usr/src/linux-git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
$ cd wireless-2.6; git checkout -b everything origin/everything
$ git show 1efded8eb6a7554748ca9486a9902fa6e86ff4a7
fatal: bad object 1efded8eb6a7554748ca9486a9902fa6e86ff4a7

My head is

$ git log | head -1
commit 301df40749bdf144c72637795ba93d82e4b84682
