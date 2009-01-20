Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f29.google.com ([209.85.219.29]:65110 "EHLO
	mail-ew0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbZATMMr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 07:12:47 -0500
Received: by ewy10 with SMTP id 10so144329ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2009 04:12:45 -0800 (PST)
Message-ID: <4975BFB6.4010205@gmail.com> (sfid-20090120_131251_882496_79738F86)
Date: Tue, 20 Jan 2009 13:12:38 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Artur Skawina <art.08.09@gmail.com>
CC: Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] p54usb: fix nasty use after free
References: <200901200027.57128.chunkeey@web.de> <4975B948.2010808@gmail.com>
In-Reply-To: <4975B948.2010808@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> The large packet loss is still there and the device is still unusable (because of
> the extremely low throughput, that 1M took several minutes to transfer and three
> attempts to associate before it worked). But no crashes, that's a huge improvement :)

this turned out to be unrelated (URB_ZERO_PACKET on both urbs fixed it, but i need to do
more tests. note that w/o the equivalent of this patch URB_ZERO_PACKET didn't help).

artur
