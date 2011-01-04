Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51571 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1ADQIc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 11:08:32 -0500
Received: by fxm20 with SMTP id 20so14198819fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Jan 2011 08:08:31 -0800 (PST)
Message-ID: <4D234604.8010602@lwfinger.net>
Date: Tue, 04 Jan 2011 10:08:36 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [PATCH] b43: N-PHY: enable support for PHYs rev 3 and higher
References: <1292963384-23684-1-git-send-email-zajec5@gmail.com> <AANLkTikwKOLJ6A-DTEuVg43_g_cWgDg2xK4M6qQ0Lm4U@mail.gmail.com>
In-Reply-To: <AANLkTikwKOLJ6A-DTEuVg43_g_cWgDg2xK4M6qQ0Lm4U@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/04/2011 09:50 AM, Rafał Miłecki wrote:
> W dniu 21 grudnia 2010 21:29 użytkownik Rafał Miłecki
> <zajec5@gmail.com> napisał:
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>> John: can we still make it for 2.6.38 merge? It was tested with 14e4:432b,
>> support seems to be on the same level as for PHYs 1 and 2.
> 
> John, I dont see patches for rev3+ in wireless-testing. Any problems with them?
> 
> It means:
> [PATCH 1/4] b43: use correct firmware for newer cores
> [PATCH 2/4 v2] b43: N-PHY: implement radio 2056 init steps
> [PATCH 3/4] b43: N-PHY: add init tables for 2056 radio
> [PATCH 4/4] b43: N-PHY: avoid PHY hangs for rev 3 and 4
> 
> [PATCH 1/2] b43: N-PHY: use correct channel tables for rev4+
> [PATCH 2/2 v2] b43: N-PHY: update 2056 radio on channel switch on rev3+
> and this one.

John,

I have been testing these patches with a 14e4:432b device for at least two
weeks. With them, the driver still does not handle WPA/WPA2 encryption and falls
over with OFDM rates, but it is rock solid with WEP encryption and at 11 Mb/s.
Rafał and I have some ideas why the limitations, but the holidays have
interfered with debugging.

Larry

