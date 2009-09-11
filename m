Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:41464 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432AbZIKNoO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 09:44:14 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH] b43: Add Soft-MAC SDIO device support
Date: Fri, 11 Sep 2009 15:44:11 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Albert Herranz <albert_herranz@yahoo.es>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>
References: <200909101934.50283.mb@bu3sch.de> <69e28c910909101423j535c9cffq5b1be1cb00877645@mail.gmail.com>
In-Reply-To: <69e28c910909101423j535c9cffq5b1be1cb00877645@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909111544.12902.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 10 September 2009 23:23:19 Gábor Stefanik wrote:
> On Thu, Sep 10, 2009 at 7:34 PM, Michael Buesch <mb@bu3sch.de> wrote:
> > From: Albert Herranz <albert_herranz@yahoo.es>
> >
> > This adds support for Soft-MAC SDIO devices to b43.
> > The driver still lacks some fixes for SDIO devices, so it's currently
> > marked as BROKEN.
> 
> Is it actually completely broken; or already testable, just incomplete?

incomplete

-- 
Greetings, Michael.
