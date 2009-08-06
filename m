Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42453 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbZHFSPz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 14:15:55 -0400
Date: Thu, 6 Aug 2009 14:15:46 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, zhifeng.cai@atheros.com,
	stephen.chen@atheros.com, linux-usb@vger.kernel.org
Subject: Re: [PATCH] pci_ids.h: add new Atheros USB vendor ID
Message-ID: <20090806181546.GA11589@redhat.com>
References: <1249523981-26601-1-git-send-email-lrodriguez@atheros.com> <1249532170.21101.3.camel@localhost.localdomain> <43e72e890908052126v53aa1b4sb7a48e19f98fdfa6@mail.gmail.com> <1249533357.21101.5.camel@localhost.localdomain> <20090806050932.GA25015@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090806050932.GA25015@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 05, 2009 at 10:09:32PM -0700, Greg Kroah-Hartman wrote:
 > > the closest we have is drivers/hid/hid-ids.h and we might just should
 > > have Greg create a usb-ids.h file.
 >
 > Ick, no, there's no such file for a good reason.  Put your device ids in
 > the driver files, no need to share it across the whole kernel.

I agree. In fact, I'd go further, and say that the bulk of what we have
in pci_ids.h is also pointlessly shared. Only a tiny fraction of the device
entries in that file are used by multiple files in the kernel.

	Dave

