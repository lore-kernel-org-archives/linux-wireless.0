Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38340 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760286Ab0KRUow (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 15:44:52 -0500
Date: Thu, 18 Nov 2010 15:40:45 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Daniel Drake <dsd@laptop.org>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	akarwar@marvell.com, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] libertas: don't block usb8388 suspend if no wakeup
 conditions are set
Message-ID: <20101118204045.GE2468@tuxdriver.com>
References: <20101031134012.F21FF9D401B@zog.reactivated.net>
 <1289604579.21000.5.camel@dcbw.foobar.com>
 <AANLkTinpvmS1ZH=T5BtA3+qyYLnNijxfjonFMaY8fO4F@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTinpvmS1ZH=T5BtA3+qyYLnNijxfjonFMaY8fO4F@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 18, 2010 at 08:15:55PM +0000, Daniel Drake wrote:
> John, just a quick ping on this maintainer-acked patch
> Thanks :)

I have it in wireless-next-2.6.  Do you think it needs to be in 2.6.37?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
