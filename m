Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:41375 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbZCEWtT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 17:49:19 -0500
Received: by fk-out-0910.google.com with SMTP id f33so68583fkf.5
        for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2009 14:49:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090304232527.058017da.cjsthompson@gmail.com>
References: <4dd58f490903041329p54ec56ceh1b64ab000027eac5@mail.gmail.com>
	 <4dd58f490903041333y4e2abe8r72204232ec4a65ac@mail.gmail.com>
	 <20090304232625.cc47eb46.cjsthompson@gmail.com>
	 <4dd58f490903041451x5044b464k47d70b1210b12f11@mail.gmail.com>
	 <20090304232527.058017da.cjsthompson@gmail.com>
Date: Thu, 5 Mar 2009 22:49:16 +0000
Message-ID: <4dd58f490903051449h3b2eb96ay5d83d7ea8129370f@mail.gmail.com> (sfid-20090305_234937_608344_62849CDE)
Subject: Re: ath5k master (AP) mode
From: Alexey Yudichev <ayudichev@yahoo.co.uk>
To: "Christoph J. Thompson" <cjsthompson@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Wed, 4 Mar 2009 22:51:01 +0000
> Alexey Yudichev <ayudichev@yahoo.co.uk> wrote:
>> Hi, I use 2.6.27-11-generic (from ubuntu's
>> linux-backports-modules-intrepid-generic), hostapd v0.5.10.
>
> I use 2.6.29-rc6 and hostapd 0.6.8. I know that on kernels < 2.6.29 you need another patch to enable AP support, not just the one that enables AP support in ath5k. If you upgrade to 2.6.29 the old regulatory rules will be disabled by default. So unless you re-enable them (but I haven't tested with that) you'll have to install crda and the wireless regulatory database. In hostapd.conf you will have to change channel=0 to something else. That's how I got it working.
>
> --
> Christoph J. Thompson <cjsthompson@gmail.com>

Thanks Christoph, looks like ubuntu is currently at 2.6.28 and I do
not want to attempt installing non-ubuntu-patched kernel. Also, what
is the driver option value in your hostapd config? Is it nl80211? And
last question, do you know anything about that "another" patch for pre
2.6.29 kernels?
