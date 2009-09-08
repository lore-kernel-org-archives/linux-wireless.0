Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:41939 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbZIHOii (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2009 10:38:38 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Dave Young <hidave.darkstar@gmail.com>
Subject: Re: b43 dma error
Date: Tue, 8 Sep 2009 16:38:35 +0200
Cc: linville@tuxdriver.com, netrolller.3d@gmail.com,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <20090908134732.GA1936@darkstar>
In-Reply-To: <20090908134732.GA1936@darkstar>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909081638.36897.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 08 September 2009 15:47:32 Dave Young wrote:
> I tested wireless-testing b43 driver, but got "Fatal DMA error"
> then the controller keep restarting...
> 
> Please tell what I can provide or test, Thanks.

Is this a regression? If so, please bisect.

-- 
Greetings, Michael.
