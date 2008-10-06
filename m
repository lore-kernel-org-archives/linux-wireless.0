Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:59824 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbYJFSU7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 14:20:59 -0400
Subject: Re: at76_usb driver status
From: Marcel Holtmann <holtmann@linux.intel.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Dan Williams <dcbw@redhat.com>, Greg KH <greg@kroah.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	"proski@gnu.org" <proski@gnu.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20081006102302.GA6288@tesla>
References: <20081002210742.GA27221@kroah.com> <87y713y48r.fsf@nokia.com>
	 <20081005061603.GB28533@kroah.com>
	 <1223306593.31040.33.camel@dhcp-100-3-195.bos.redhat.com>
	 <20081006102302.GA6288@tesla>
Content-Type: text/plain
Date: Mon, 06 Oct 2008 20:21:17 +0200
Message-Id: <1223317277.11272.222.camel@violet.holtmann.net> (sfid-20081006_202115_189231_C76E137E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

> > Well, you have to ask yourself then, what's the point of putting that
> > driver with it's own 802.11 stack into staging when it's never going to
> > go into the mainline kernel until it uses mac80211?
> 
> And provided that there is an alternative driver that uses mac80211. Die
> out of tree drivers, die.

I can only second that. If it is a SoftMAC and not using mac80211 then
it is not even worth it. We want the mac80211 ported driver to go
upstream. Everything else is just waste of time.

Regards

Marcel


