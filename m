Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:15583 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbYK0XKe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2008 18:10:34 -0500
Received: by ug-out-1314.google.com with SMTP id 39so1843985ugf.37
        for <linux-wireless@vger.kernel.org>; Thu, 27 Nov 2008 15:10:31 -0800 (PST)
Message-ID: <3ace41890811271510t6879dc6q7022779e985d8f6a@mail.gmail.com> (sfid-20081128_001039_157692_56F39A74)
Date: Thu, 27 Nov 2008 23:10:31 +0000
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: "Herton Ronaldo Krzesinski" <herton@mandriva.com.br>
Subject: Re: [RFC] rtl8187: Do not wait for an ACK when IEEE80211_TX_CTL_NO_ACK is set
Cc: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200811271952.21408.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <69e28c910811261431u26e341d3p51ebadca807f4b61@mail.gmail.com>
	 <200811271543.59126.herton@mandriva.com.br>
	 <69e28c910811271202s295bbf5bo3dc8c04c50b08a01@mail.gmail.com>
	 <200811271952.21408.herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 27, 2008 at 9:52 PM, Herton Ronaldo Krzesinski
<herton@mandriva.com.br> wrote:
<snipped>
>> Also, v26.1010 of the vendor driver does exactly what my patch does.
>
> Is this newer than 26.1036.0708.2008 I have here? The version it never sets 0,
> in code there is this:
<snipped>
> I didn't found this version 26.1010 to download, do you know where I can get?

26.1010 is the non-B driver - I happened to have it on my hard disc -
the url is
ftp://152.104.238.19/cn/wlan/rtl8187_linux_26.1010.zip .

it is quite old - it unpacks to rtl8187_linux_26.1010.0622.2006 -
which as far as my understanding of the naming goes,
is for 2.6 kernel, release 1010, on 2006 June 22nd, so it is a lot
older than every B vendor driver we have.

Hin-Tak
