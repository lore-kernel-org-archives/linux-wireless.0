Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23108.mail.ird.yahoo.com ([217.146.189.48]:40397 "HELO
	web23108.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750756AbYKAAHr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 20:07:47 -0400
Date: Sat, 1 Nov 2008 00:07:45 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [RFC/RFT PATCH 0/2] rtl8187: implement conf_tx callback/correctly ack tx pkts
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
In-Reply-To: <490B957E.8020406@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <405096.56076.qm@web23108.mail.ird.yahoo.com> (sfid-20081101_010752_215270_19C9391E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--- On Fri, 31/10/08, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> With these patches installed, my RTL8187B device was stuck
> at 1 Mbs using the
> 'pid' algorithm. Without them, the rate rapidly
> increases to 54 Mbs. I'm roughly
> 2 m from my AP, and get an indicated signal of -22 dBm and
> a link quality of
> 98/100. My kernel is from wireless-testing
> (v2.6.28-rc2-4159-g6c11cd2) with the
> rtl8187 power control and timing patches submitted earlier.
> There are no changes
> to any of the mac80211 components.

This behavior was mentioned in Herton's e-mail, and said to be likely due to recent rewrite of the rate-control api?

I am still using the early incarnation of the rate-control patch with 2.6.26.7-86.fc9.x86_64 and 2.6.27.4-69.fc10.x86_64 (by rolling back wireless-testing to 2.6.27.x to match), and my rate does go up and down (between 11M to 36M just now) and generally feels more responsive. Apologies I haven't looked at the newly posted rate-control patch yet - is there any significant code difference?

Hin-Tak

Hin-Tak


      
