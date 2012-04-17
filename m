Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ivanich.tenet.odessa.ua ([85.238.100.22]:60846 "EHLO
	ivanich.org.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab2DQG6o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 02:58:44 -0400
From: Ivan Ivanich <ivanich@ivanich.org.ua>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, spams@ivanich.org.ua,
	linux-wireless@vger.kernel.org
Subject: Re: Regression in kernel-3.4-rcx with rtl8192ce
Date: Tue, 17 Apr 2012 09:39:09 +0300
Message-ID: <1398961.lm5Ddc5cdv@ivanich.org.ua> (sfid-20120417_085848_489568_E973CE5D)
In-Reply-To: <4F8CAB25.9000302@openwrt.org>
References: <2054318.iQACctbcH2@ivanich.org.ua> <4F8C9DDD.5080704@lwfinger.net> <4F8CAB25.9000302@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Вторник, 17-апр-2012 01:28:37 Felix Fietkau wrote:
> On 2012-04-17 12:31 AM, Larry Finger wrote:
> > On 04/16/2012 04:52 PM, spams@ivanich.org.ua wrote:
> >> I'm using rtl8188ce in AP mode with hostapd, after upgrade to 3.4-rcx
> >> kernel(tried 3.4-rc2,rc3 and latest source from wireless-next.git) I
> >> can't
> >> connect to my AP.
> >> AP Log:
> >> Apr 16 23:31:39 localhost hostapd: wlan0: STA d8:b3:cf:d1:a0:58 IEEE
> >> 802.11: authenticated
> >> Apr 16 23:31:39 localhost hostapd: wlan0: STA d8:b3:cf:d1:a0:58 IEEE
> >> 802.11: Station sent an invalid association request
> >> 
> >> Tried disabling and enabling different options in hostapd.conf but with
> >> no
> >> luck. With kernels-3.3.x it works just fine.
> >> Thank you.
> > 
> > Please bisect this using the wireless-testing git source. From what I
> > remember, there are no changes in the rtlwifi/rtl8192c/rtl8192ce that
> > should affect this situation.
> 
> Try applying my patch "mac80211: fix truncated packets in cooked monitor
> rx" - I had issues with AP mode in ath9k as well and fixed them with
> that one.
> 
> - Felix
Felix.
Applyied your patch and it helps. Thank you.

