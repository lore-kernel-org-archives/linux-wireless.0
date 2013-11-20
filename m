Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:62999 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab3KTH0K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 02:26:10 -0500
Received: by mail-vc0-f171.google.com with SMTP id ik5so87715vcb.30
        for <linux-wireless@vger.kernel.org>; Tue, 19 Nov 2013 23:26:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFSJ42ZLhh5ns-aaO8G38TH1em37iHnYKvgF7BjSK-ZhA7jNcA@mail.gmail.com>
References: <1384870413-5569-1-git-send-email-yeohchunyeow@gmail.com>
	<CAFSJ42ZLhh5ns-aaO8G38TH1em37iHnYKvgF7BjSK-ZhA7jNcA@mail.gmail.com>
Date: Wed, 20 Nov 2013 15:26:09 +0800
Message-ID: <CAEFj986hb2BLvcF2Bz3jRb_BRq3b+jZ5FwWALc0gdjXhLFU8tA@mail.gmail.com> (sfid-20131120_082614_375690_CF51466B)
Subject: Re: [PATCH] wcn36xx: set self sta entry as HT capable
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	wcn36xx <wcn36xx@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Eugene

> Why would the function that is setting default HT params will also set
> default rates? There is no connection between HT params and default
> rates.
How about rename the function name to wcn36xx_smd_set_self_sta?

----
Chun-Yeow
