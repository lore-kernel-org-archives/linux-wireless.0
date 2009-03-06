Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:53161 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbZCFIT4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 03:19:56 -0500
Received: by fg-out-1718.google.com with SMTP id 16so497320fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 06 Mar 2009 00:19:53 -0800 (PST)
Date: Fri, 6 Mar 2009 08:45:27 +0100
From: "Christoph J. Thompson" <cjsthompson@gmail.com>
To: Alexey Yudichev <ayudichev@yahoo.co.uk>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath5k master (AP) mode
Message-Id: <20090306084527.5a3b6300.cjsthompson@gmail.com> (sfid-20090306_092000_332530_A22BCA1D)
In-Reply-To: <4dd58f490903051449h3b2eb96ay5d83d7ea8129370f@mail.gmail.com>
References: <4dd58f490903041329p54ec56ceh1b64ab000027eac5@mail.gmail.com>
	<4dd58f490903041333y4e2abe8r72204232ec4a65ac@mail.gmail.com>
	<20090304232625.cc47eb46.cjsthompson@gmail.com>
	<4dd58f490903041451x5044b464k47d70b1210b12f11@mail.gmail.com>
	<20090304232527.058017da.cjsthompson@gmail.com>
	<4dd58f490903051449h3b2eb96ay5d83d7ea8129370f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 5 Mar 2009 22:49:16 +0000
Alexey Yudichev <ayudichev@yahoo.co.uk> wrote:
> Thanks Christoph, looks like ubuntu is currently at 2.6.28 and I do
> not want to attempt installing non-ubuntu-patched kernel. Also, what
> is the driver option value in your hostapd config? Is it nl80211? And
> last question, do you know anything about that "another" patch for pre
> 2.6.29 kernels?

Hi,

Yes, the driver option value is nl80211. This is the patch you are looking for I think:

http://johannes.sipsolutions.net/patches/kernel/all/LATEST/030-allow-ap-vlan-modes.patch


-- 
Christoph J. Thompson <cjsthompson@gmail.com>
