Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:50773 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbYELLLH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 07:11:07 -0400
Subject: Re: at76_usb driver for WUSB11 v.26 wireless adapter doesn't work
	for kernels newer than 2.6.24.3-12.fc8
From: Pavel Roskin <proski@gnu.org>
To: Fred Odendaal <freshshelf@rogers.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4820FFCD.7060905@rogers.com>
References: <4820FFCD.7060905@rogers.com>
Content-Type: text/plain
Date: Mon, 12 May 2008 07:11:05 -0400
Message-Id: <1210590665.11848.15.camel@dv> (sfid-20080512_131112_193494_28E96A04)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-05-06 at 21:03 -0400, Fred Odendaal wrote:
> There is a bug report for this here: 
> https://bugzilla.redhat.com/show_bug.cgi?id=438606
> 
> Essentially, this driver used to work, but no longer does. The driver 
> doesn't seem to be able to communicate signal level and link quality.
> 
> If someone needs me to test a fix for this, or to try test loads I'm 
> willing to help.

It's a known problem.  There are some patches by Milan Plzik in
at76c503a-develop@lists.berlios.de that may help, but they need to be
reviewed and tested.

-- 
Regards,
Pavel Roskin
