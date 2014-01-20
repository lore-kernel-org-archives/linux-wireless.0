Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34354 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbaATTcE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 14:32:04 -0500
Date: Mon, 20 Jan 2014 11:32:49 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-wireless@vger.kernel.org
Subject: Realtek 8821 wireless PCI driver?
Message-ID: <20140120193249.GA25707@kroah.com> (sfid-20140120_203208_092639_61CD053B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I have a box here with a Realtek 8821 wireless PCI device.  We don't
seem to have a driver upstream for it yet, but there's a huge tarball
from Realtek on their site.

Has anyone started picking the needed pieces out of the tarball to get
this merged "properly", or does this need to be done yet?

Hm, I wonder if I should just dump the tarball into staging for now, to
get my box working, any objections to me doing that?

thanks,

greg k-h
