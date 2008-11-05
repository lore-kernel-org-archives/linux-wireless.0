Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23107.mail.ird.yahoo.com ([217.146.189.47]:23606 "HELO
	web23107.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751826AbYKEXQo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 18:16:44 -0500
Date: Wed, 5 Nov 2008 23:16:42 +0000 (GMT)
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: Re: [RFC/RFT PATCH v2 2/2] rtl8187: feedback transmitted packets using tx close descriptor for 8187B
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
In-Reply-To: <20081105224329.GC9028@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <943428.93674.qm@web23107.mail.ird.yahoo.com> (sfid-20081106_001649_386434_1260EAC3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Wed, 5/11/08, Luis R. Rodriguez <lrodriguez@atheros.com> wrote:
> Umm I have an FC10 box and I see a mac80211.ko. But of
> course, I have an
> early release of FC10, its on
> 2.6.27-0.244.rc2.git1.fc10.x86_64.
> 
> Did the new ones really put it built in?

Yes, 
$ grep 'MAC80211=' /boot/config-2.6.2*fc10*
/boot/config-2.6.27.4-69.fc10.x86_64:CONFIG_MAC80211=y
/boot/config-2.6.27.4-73.fc10.x86_64:CONFIG_MAC80211=y

I looked through koji and found it was removed between 
0.345.rc7.fc10
0.339.rc7.fc10
but the log entry between does not say why.

I filed this as https://bugzilla.redhat.com/show_bug.cgi?id=470143 ,
if John wants to grab it before somebody else assign it his way :-).

Hin-Tak








      
