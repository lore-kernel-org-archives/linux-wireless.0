Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost04.isp.att.net ([204.127.217.104]:45743 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948AbZDSTxU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 15:53:20 -0400
Message-ID: <49EB8119.1020402@lwfinger.net> (sfid-20090419_215324_704513_34056C71)
Date: Sun, 19 Apr 2009 14:52:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Forest Bond <forest@alittletooquiet.net>
CC: Greg KH <greg@kroah.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
References: <20090414105200.GE25746@storm.local.network> <1239707258.4778.3.camel@johannes.local> <20090414113928.GA20470@storm.local.network> <1239709727.4778.6.camel@johannes.local> <1239712106.11795.21.camel@violet> <1239713034.17109.10.camel@johannes.local> <20090414130248.GA3291@tuxdriver.com> <20090414141852.GB20470@storm.local.network> <20090415011020.GC10045@kroah.com> <20090415015116.GJ20470@storm.local.network> <20090419170950.GA28885@storm.local.network>
In-Reply-To: <20090419170950.GA28885@storm.local.network>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Forest Bond wrote:
> 
> However, I did have a question:
> 
> The vt6655 driver builds viawget.ko, and the vt6656 driver builds vntwusb.ko.
> Should the directories be named "viawget" and "vntwusb," respectively, or is it
> appropriate for them to be named "vt6655" and "vt6656"?

Of course Greg has the final say, but I vote to keep the directories with the
vt6656 name and change the name of the driver, which is defined in  the line
#define DEVICE_NAME "vntwusb" in file include/device_cfg.h in the vendor driver.

Larry
