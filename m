Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37280 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbZA2UPx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 15:15:53 -0500
Date: Thu, 29 Jan 2009 14:47:44 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: Vivek Natarajan <vivek.natraj@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Cancel the dynamic ps timer in
	ioctl_siwpower.
Message-ID: <20090129194743.GA6085@tuxdriver.com> (sfid-20090129_211556_207936_1AC14DE0)
References: <20090127135628.GA32059@myhost.users.atheros.com> <87hc3hopy4.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87hc3hopy4.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 29, 2009 at 09:46:43PM +0200, Kalle Valo wrote:
> Vivek Natarajan <vivek.natraj@gmail.com> writes:
> 
> > If the dynamic power save timer has been started before the power save
> > is disabled using iwconfig, we fail to cancel the timer. Hence cancel it
> > while disabling power save.
> >
> > Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> 
> Even though John already applied this:
> 
> Reviewed-by: Kalle Valo <kalle.valo@nokia.com>

Always good to speak-up, since sometimes (as in this case) it might
not have been sent upstream yet! :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
