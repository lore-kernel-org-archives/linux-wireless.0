Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23107.mail.ird.yahoo.com ([217.146.189.47]:33585 "HELO
	web23107.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755810AbZA0Tli convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 14:41:38 -0500
Date: Tue, 27 Jan 2009 19:41:36 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [RFT V2] rtl8187: Fix OFDM power settings for RTL8187L
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Hauke Mehrtens <hauke@hauke-m.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	barreyromartin@gmail.com, linux-wireless@vger.kernel.org
In-Reply-To: <497F5F70.50304@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <174904.43435.qm@web23107.mail.ird.yahoo.com> (sfid-20090127_204142_816881_07F89C9D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Tue, 27/1/09, Hauke Mehrtens <hauke@hauke-m.de> wrote:

> Hi Larry,
> 
> With this patch included and pid the rate goes up to
> 24Mb/s, but the
> connection is stable. Without this patch is is only up to
> 11Mb/s. The
> connection is still unusable with minstrel, it goes up too
> fare. It
> starts with 24Mb/s and the connection drops. After some
> time it goes up
> to 54Mb/s, but then it goes down again and the connection
> is working
> again for a minute till the procedure begins again.
> 
> What do you mean with rc_stats ?

if you have mac80211 debug switched on, 

cat /sys/kernel/debug/ieee80211/phyXX/stations/<MAC ADDR>/rc_stats

shows some rc_stats info... where XX and <MAC_ADDRESS> differs depending on your config/setup.


      
