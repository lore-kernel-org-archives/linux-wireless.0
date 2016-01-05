Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38271 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbcAEQA1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 11:00:27 -0500
Message-ID: <1452009624.12357.43.camel@sipsolutions.net> (sfid-20160105_170032_639997_0BA15F7E)
Subject: Re: Android with mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Gucea Doru <gucea.doru@gmail.com>, linux-wireless@vger.kernel.org
Date: Tue, 05 Jan 2016 17:00:24 +0100
In-Reply-To: <CANfLQrZt=pmn2OcU2riTzG5gExY8G8zji1HZnQ_1Fcrx2Jb33w@mail.gmail.com> (sfid-20160104_173422_241184_127CC5AC)
References: <CANfLQrZt=pmn2OcU2riTzG5gExY8G8zji1HZnQ_1Fcrx2Jb33w@mail.gmail.com>
	 (sfid-20160104_173422_241184_127CC5AC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-01-04 at 17:34 +0100, Gucea Doru wrote:
> Hello folks,
> 
> Is there any Android smartphone that uses the mac80211 framework for
> Wi-Fi management (e.g: driver with support for mac80211)?

Very few. There used to be phones with TI chipset that did.

Another one is this platform:

https://software.intel.com/en-us/blogs/2015/04/09/introducing-intel-
atom-x3-code-named-sofia-soc-processor-series

which (essentially) uses the 'iwlwifi' driver with mac80211.

johannes
