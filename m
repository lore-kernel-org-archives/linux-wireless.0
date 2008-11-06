Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37126 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885AbYKFObJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 09:31:09 -0500
Date: Thu, 6 Nov 2008 09:14:57 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
Subject: Re: [RFC/RFT PATCH v2 2/2] rtl8187: feedback transmitted packets
	using tx close descriptor for 8187B
Message-ID: <20081106141456.GD14184@tuxdriver.com> (sfid-20081106_153133_618470_C7BD8218)
References: <20081105224329.GC9028@tesla> <943428.93674.qm@web23107.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <943428.93674.qm@web23107.mail.ird.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 05, 2008 at 11:16:42PM +0000, Hin-Tak Leung wrote:
> --- On Wed, 5/11/08, Luis R. Rodriguez <lrodriguez@atheros.com> wrote:
> > Umm I have an FC10 box and I see a mac80211.ko. But of
> > course, I have an
> > early release of FC10, its on
> > 2.6.27-0.244.rc2.git1.fc10.x86_64.
> > 
> > Did the new ones really put it built in?
> 
> Yes, 
> $ grep 'MAC80211=' /boot/config-2.6.2*fc10*
> /boot/config-2.6.27.4-69.fc10.x86_64:CONFIG_MAC80211=y
> /boot/config-2.6.27.4-73.fc10.x86_64:CONFIG_MAC80211=y
> 
> I looked through koji and found it was removed between 
> 0.345.rc7.fc10
> 0.339.rc7.fc10
> but the log entry between does not say why.
> 
> I filed this as https://bugzilla.redhat.com/show_bug.cgi?id=470143 ,
> if John wants to grab it before somebody else assign it his way :-).

That decision was made against my advice -- I don't know that I can
change it.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
