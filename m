Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34207 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbcA2QQB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 11:16:01 -0500
Message-ID: <1454084146.2800.0.camel@sipsolutions.net> (sfid-20160129_171618_812101_CC4F2533)
Subject: Re: WARNING at net/mac80211/rate.c:513 ieee80211_get_tx_rates
 [mac80211]
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>,
	David Miller <davem@davemloft.net>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>
Date: Fri, 29 Jan 2016 17:15:46 +0100
In-Reply-To: <CAP71bdVZzUUNwP3py_m1pwU21qMKth=0BmMfLuUb7=B-1840zg@mail.gmail.com> (sfid-20160129_171252_956705_2E9111CB)
References: <CA+55aFxe22iWok6UojY=hCoG2k1wNpJ9CfQ0b+STSxq67tb86Q@mail.gmail.com>
	 <1453983185.2217.12.camel@sipsolutions.net>
	 <CA+55aFya9K4JboNY8kB9cg6zt9otguhdzfHm3jvLmWedxQTSWg@mail.gmail.com>
	 <1454013625.2332.9.camel@sipsolutions.net>
	 <CA+55aFx73nv9ny-fu5BR6v8wL=f2oFomwrZoLRw=x2kNP76cYA@mail.gmail.com>
	 <CA+55aFzF0gWfvmE+6ZcHmjnO4xp-oVAQ5SWxYJhOzns2ocgCsw@mail.gmail.com>
	 <1454019155.2332.15.camel@sipsolutions.net>
	 <CA+55aFxjpdepHYD_6uU48kW38Z9bmf2wwA8yPZt4ibhkofmfQA@mail.gmail.com>
	 <56AAC66C.1080800@lwfinger.net> <1454056380.3369.2.camel@sipsolutions.net>
	 <CAP71bdVZzUUNwP3py_m1pwU21qMKth=0BmMfLuUb7=B-1840zg@mail.gmail.com>
	 (sfid-20160129_171252_956705_2E9111CB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-01-29 at 10:12 -0600, Larry Finger wrote:
> 
> Upon further inspection, my log has the line "rtl8821ae 0000:02:00.0
> wlp2s0: disabling HT/VHT due to WEP/TKIP use". I need to fix that
> first.
> 
Likely TKIP; enable only WPA2 (CCMP) on the AP.

johannes
