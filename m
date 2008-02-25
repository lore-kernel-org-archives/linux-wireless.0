Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:41564 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757519AbYBYW1M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 17:27:12 -0500
Received: by wf-out-1314.google.com with SMTP id 28so986653wff.4
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 14:27:11 -0800 (PST)
Message-ID: <a32f33a40802251427w678d57c1g1b85d7e72830a89e@mail.gmail.com> (sfid-20080225_222727_009027_A0207BED)
Date: Mon, 25 Feb 2008 23:27:11 +0100
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "Ahmed Ammar" <b33fc0d3@gmail.com>
Subject: Re: b43 (H/W 4306 Rev. 03)
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Adam Baker" <linux@baker-net.org.uk>
In-Reply-To: <84ac67910802250407p527cdee3uc33a572130f41f8d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <84ac67910802210444q4da4f02bo2d172493ef2c7158@mail.gmail.com>
	 <84ac67910802230559g73dafb0focbf62f4b9a6b3158@mail.gmail.com>
	 <1203776102.13162.27.camel@johannes.berg>
	 <84ac67910802230628q217542e4gc76bed8076af118f@mail.gmail.com>
	 <1203777414.13162.29.camel@johannes.berg>
	 <84ac67910802230925xb7750e8j561efaf951c50321@mail.gmail.com>
	 <1203794030.13162.39.camel@johannes.berg>
	 <84ac67910802231156t29724612me8adb74d05bfede8@mail.gmail.com>
	 <1203933155.13162.56.camel@johannes.berg>
	 <84ac67910802250407p527cdee3uc33a572130f41f8d@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Hmm,
>
>  Well I can only blame the bad rt61pci drivers, I'm out of options now.

Yes, rt61pci is known to be buggy in monitor mode, there seem
to be some inconsistencies regarding frame filtering inside the device
which causes rt61pci to incorrectly filter some frames out.

It is an issue being looked into, and I believe Adam Baker already has
some patches he will send in for rt2x00 soon (First some other TX/RX
bugs needed to be fixed).

Ivo
