Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx03.syneticon.net ([78.111.66.105]:37630 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbZFRUPx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 16:15:53 -0400
Message-ID: <4A3AA08E.4050400@wpkg.org>
Date: Thu, 18 Jun 2009 22:16:14 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: ath5k AP support?
References: <4A381159.70301@wpkg.org> <b6c5339f0906161454tbdaf382k654450a9f1cf8ae7@mail.gmail.com>
In-Reply-To: <b6c5339f0906161454tbdaf382k654450a9f1cf8ae7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland wrote:
> On Tue, Jun 16, 2009 at 5:40 PM, Tomasz Chmielewski<mangoo@wpkg.org> wrote:
>> According to http://linuxwireless.org/en/users/Drivers/ath5k, AP mode is
>> "reported to work, we just need some further tests on all cards to be sure".
>>
>> I just tried it with 2.6.30 kernel with this card:
> 
> 2.6.30 does not enable AP mode, you should try the wireless-testing
> tree instead.
> 
> There is at least one known bug (the patch at the end is broken but
> close):  http://bugzilla.kernel.org/show_bug.cgi?id=13237

I tried compat-wireless-2009-06-17, but I can't connect:

Jun 18 22:12:31 mangoo hostapd: wlan1: STA 00:23:08:78:d4:5f IEEE 802.11: authenticated
Jun 18 22:12:31 mangoo hostapd: wlan1: STA 00:23:08:78:d4:5f IEEE 802.11: associated (aid 1)
Jun 18 22:12:34 mangoo hostapd: wlan1: STA 00:23:08:78:d4:5f IEEE 802.11: deauthenticated due to local deauth request
Jun 18 22:12:40 mangoo hostapd: wlan1: STA 00:23:08:78:d4:5f IEEE 802.11: authenticated
Jun 18 22:12:40 mangoo hostapd: wlan1: STA 00:23:08:78:d4:5f IEEE 802.11: associated (aid 1)
Jun 18 22:12:43 mangoo hostapd: wlan1: STA 00:23:08:78:d4:5f IEEE 802.11: deauthenticated due to local deauth request
Jun 18 22:12:55 mangoo hostapd: wlan1: STA 00:23:08:78:d4:5f IEEE 802.11: authenticated
Jun 18 22:12:55 mangoo hostapd: wlan1: STA 00:23:08:78:d4:5f IEEE 802.11: associated (aid 1)
Jun 18 22:12:58 mangoo hostapd: wlan1: STA 00:23:08:78:d4:5f IEEE 802.11: deauthenticated due to local deauth request
(...)


I didn't try your patch.


-- 
Tomasz Chmielewski
http://wpkg.org
