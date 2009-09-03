Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39464 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbZICNA2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2009 09:00:28 -0400
Date: Thu, 3 Sep 2009 07:55:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Amit Kucheria <amit.kucheria@canonical.com>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>
Subject: Re: [PATCH] rt2x00: Get rid of duplicate usb id from rt2500usb
Message-ID: <20090903115521.GB12597@tuxdriver.com>
References: <1251978140-4992-1-git-send-email-amit.kucheria@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1251978140-4992-1-git-send-email-amit.kucheria@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 03, 2009 at 02:42:20PM +0300, Amit Kucheria wrote:
> USB_DEVICE(0x148f, 0x2573) is served by the rt73usb driver where it is already
> defined. Remove it from rt2500usb.
> 
> Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>

IIRC there are IDs that are used by different devices where rt73usb
covers one device and the rt2500usb covers another.  Are you sure
this is not one of those?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
