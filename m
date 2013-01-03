Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout10.t-online.de ([194.25.134.21]:53024 "EHLO
	mailout10.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab3ACJs0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 04:48:26 -0500
Message-ID: <50E553D8.7000609@web.de> (sfid-20130103_104829_174132_084E9C92)
Date: Thu, 03 Jan 2013 10:48:08 +0100
From: =?ISO-8859-1?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: wireless regression with 3.7 on MSI MS-1013 notebook
References: <50E42DBF.7070206@web.de> <20130102160534.GC2198@tuxdriver.com> <CAL1gcdMXNomEiPqJ5fKiQEB8Z02h=zYyYEUyDPvcaH4uEmd6jA@mail.gmail.com> <CAL1gcdN7TBS_yn5q5YsNVt8pkfLrxJLj=JSYQzM0J0jTEFAx-Q@mail.gmail.com>
In-Reply-To: <CAL1gcdN7TBS_yn5q5YsNVt8pkfLrxJLj=JSYQzM0J0jTEFAx-Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

@John W.: To be more precise: the problem happened every time, the module
pci2500pci was loaded. I was able to unload the module with "modprobe -r
rt2500pci"  and reload it which triggered the warning. The warning appeared even
if the WLAN device was switched off (via the hardware switch).

-- 
Best regards,
Jörg-Volker.
