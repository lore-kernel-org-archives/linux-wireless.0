Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48963 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759173Ab0KPVYP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 16:24:15 -0500
Received: by pwj1 with SMTP id 1so92025pwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Nov 2010 13:24:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101116210247.GE10774@tuxdriver.com>
References: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
	<20101116210247.GE10774@tuxdriver.com>
Date: Tue, 16 Nov 2010 22:24:13 +0100
Message-ID: <AANLkTimQzkenikBzf9r_+H9YOWkLauKnwjBso-TdaHaS@mail.gmail.com>
Subject: Re: [PATCH 00/18] update for 2.6.38
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/11/16 John W. Linville <linville@tuxdriver.com>:
> On Tue, Nov 16, 2010 at 08:01:33AM -0800, Wey-Yi Guy wrote:
>> We add more changes to prepare P2P supports
>> We also add few features/changes to WiFi/BT coex,
>> such as dynamic aggregation.
>> For newer devices, we change the default LED mode to On/Off
>
> There had been some talk of a firmware update that would solve some
> user-reported bugs on bugzilla.kernel.org.  I don't have the bug
> numbers handy, but I can probably find them.  I imagine you can find
> them quite easily as well.
>
> Is that firmware update still in the works?  When can we expect to
> see that?

http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2214#c19

The last time I got answer to my criticism I felt mean for my hard bad
words. But there's another half of month without fix/update.

The fix is expected to come with firmware update, not driver update.

-- 
Rafał
