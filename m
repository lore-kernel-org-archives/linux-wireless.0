Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:24024 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbYKJJDT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2008 04:03:19 -0500
To: "David Shwatrz" <dshwatrz@gmail.com>
Cc: "Ivo van Doorn" <ivdoorn@gmail.com>, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: Re: Where is allow-ap-vlan-modes.patch ?
References: <31436f4a0811090701r4676409er8f53a32c91bc3ced@mail.gmail.com>
	<200811091604.43705.IvDoorn@gmail.com>
	<31436f4a0811100048h5c7520d3ga4eedd815f8c793a@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 10 Nov 2008 11:02:22 +0200
In-Reply-To: <31436f4a0811100048h5c7520d3ga4eedd815f8c793a@mail.gmail.com> (ext David Shwatrz's message of "Mon\, 10 Nov 2008 10\:48\:25 +0200")
Message-ID: <874p2g0x9d.fsf@nokia.com> (sfid-20081110_100325_389033_7A983F60)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Shwatrz <dshwatrz@gmail.com> writes:

> In this occasion may I ask - what is the wireless-testing git tree?
> is it based on wireless-next-2.6 or on wireless-2.6 tree?

It's based on Linus' rc releases and has all the wireless patches
which have been under development. I think John cherry picks the
patches from wireless-testing to wireless-2.6 or wireless-next-2.6. So
wireless-testing contains the bleeding edge wireless patches and if
John thinks they are good enough, he submits them forward.

Please correct me if I have understood something wrong.

-- 
Kalle Valo
