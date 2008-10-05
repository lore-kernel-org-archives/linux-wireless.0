Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:45757 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbYJEG3m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Oct 2008 02:29:42 -0400
To: Greg KH <greg@kroah.com>
Cc: proski@gnu.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: at76_usb driver status
References: <20081002210742.GA27221@kroah.com> <87y713y48r.fsf@nokia.com>
	<20081005061603.GB28533@kroah.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 05 Oct 2008 09:29:14 +0300
In-Reply-To: <20081005061603.GB28533@kroah.com> (Greg KH's message of "Sat\, 4 Oct 2008 23\:16\:03 -0700")
Message-ID: <87d4ifsgg5.fsf@litku.valot.fi> (sfid-20081005_082946_170202_FF1BCA88)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg KH <greg@kroah.com> writes:

>> > So I was wondering what the status of this driver is, and if I
>> > could/should add it to drivers/staging/?
>> 
>> The original at76_usb is working quite well, but it's unacceptable for
>> the mainline because we cannot have two 802.11 stacks in kernel.
>
> I understand this, but for the issue of the drivers/staging/ tree, it's
> ok for us to have as many 802.11 stacks in the kernel as we can cram in
> there :)

That's good.

> See my previous posts on lkml for details on the staging tree if you
> have questions about it.
>
> So for now, if no one really screams, I'll put Pavel's driver into the
> drivers/staging/ tree so that users can use their devices.  When your
> driver is merged, we can merely delete this driver instead.
>
> Sound good?

That sounds very good. User's benefit from this and that's what
counts.

BTW, Pavel doesn't have time for at76 anymore. So if you have any
problems with Pavel's driver in the stating tree, I can help you.

-- 
Kalle Valo
