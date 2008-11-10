Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:50877 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbYKJVgg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2008 16:36:36 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: "Hin-Tak Leung" <hintak_leung@yahoo.co.uk>
Subject: Re: throughput problem Re: [RFC/RFT PATCH v2 2/2] rtl8187: feedback transmitted packets using tx close descriptor for 8187B
Date: Mon, 10 Nov 2008 19:36:49 -0200
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
References: <349181.30158.qm@web23105.mail.ird.yahoo.com>
In-Reply-To: <349181.30158.qm@web23105.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200811101936.49887.herton@mandriva.com.br> (sfid-20081110_223640_995190_DF19F00A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 09 November 2008 04:01:03 Hin-Tak Leung wrote:
> Without any additional modification, just compat-wireless and
> wireles-testing v2.6.28-rc3-4651-gb53846d has a preculiar problem - the
> rate is stuck at 54Mb (known issue to be addressed by Herton's feedback
> patch) as shown by iwconfig, but sftp doesn't transfer file much higher
> than 30-40kB/s. blowing away /lib/module/`uname -r`/updates (i.e. reverting
> to the as shipped 2.6.27.5 rtl8187 & mac80211 ) gives easily over 10 times
> that speed. anybody seen this problem (with rtl8187 or other mac80211
> driver with wireless testing)?

Here I don't get such low transfer rate, may be a regression in 
wireless-testing? Try a bisect to see, besides that I don't have other ideas 
what could be. BTW, do you checked wireless-testing, so can I add your 
tested-by then to the "feedback transmitted packets..."  patch? I plan to 
submit the final patch to inclusion in wireless-testing soon.

--
[]'s
Herton
