Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:33015 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbZCDW74 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2009 17:59:56 -0500
Received: by nf-out-0910.google.com with SMTP id d21so698004nfb.21
        for <linux-wireless@vger.kernel.org>; Wed, 04 Mar 2009 14:59:53 -0800 (PST)
Date: Wed, 4 Mar 2009 23:25:27 +0100
From: "Christoph J. Thompson" <cjsthompson@gmail.com>
To: Alexey Yudichev <ayudichev@yahoo.co.uk>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath5k master (AP) mode
Message-Id: <20090304232527.058017da.cjsthompson@gmail.com> (sfid-20090304_235957_813832_60D570A2)
In-Reply-To: <4dd58f490903041451x5044b464k47d70b1210b12f11@mail.gmail.com>
References: <4dd58f490903041329p54ec56ceh1b64ab000027eac5@mail.gmail.com>
	<4dd58f490903041333y4e2abe8r72204232ec4a65ac@mail.gmail.com>
	<20090304232625.cc47eb46.cjsthompson@gmail.com>
	<4dd58f490903041451x5044b464k47d70b1210b12f11@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 4 Mar 2009 22:51:01 +0000
Alexey Yudichev <ayudichev@yahoo.co.uk> wrote:
> Hi, I use 2.6.27-11-generic (from ubuntu's
> linux-backports-modules-intrepid-generic), hostapd v0.5.10.

I use 2.6.29-rc6 and hostapd 0.6.8. I know that on kernels < 2.6.29 you need another patch to enable AP support, not just the one that enables AP support in ath5k. If you upgrade to 2.6.29 the old regulatory rules will be disabled by default. So unless you re-enable them (but I haven't tested with that) you'll have to install crda and the wireless regulatory database. In hostapd.conf you will have to change channel=0 to something else. That's how I got it working.

-- 
Christoph J. Thompson <cjsthompson@gmail.com>
