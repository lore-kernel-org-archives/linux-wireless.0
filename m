Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34907 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbYJFRXP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 13:23:15 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 06 Oct 2008 10:23:15 -0700
Date: Mon, 6 Oct 2008 03:23:02 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Dan Williams <dcbw@redhat.com>
CC: Greg KH <greg@kroah.com>, Kalle Valo <kalle.valo@iki.fi>,
	"proski@gnu.org" <proski@gnu.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: at76_usb driver status
Message-ID: <20081006102302.GA6288@tesla> (sfid-20081006_192317_319477_DC3699AD)
References: <20081002210742.GA27221@kroah.com> <87y713y48r.fsf@nokia.com> <20081005061603.GB28533@kroah.com> <1223306593.31040.33.camel@dhcp-100-3-195.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1223306593.31040.33.camel@dhcp-100-3-195.bos.redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 06, 2008 at 08:23:13AM -0700, Dan Williams wrote:
> Well, you have to ask yourself then, what's the point of putting that
> driver with it's own 802.11 stack into staging when it's never going to
> go into the mainline kernel until it uses mac80211?

And provided that there is an alternative driver that uses mac80211. Die
out of tree drivers, die.

  Luis
