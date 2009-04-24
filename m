Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:41760
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754155AbZDXU6v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2009 16:58:51 -0400
Message-ID: <49F227F8.2060504@am.sony.com> (sfid-20090424_225858_026394_26DC36BB)
Date: Fri, 24 Apr 2009 13:58:32 -0700
From: Geoff Levand <geoffrey.levand@am.sony.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: jgarzik@pobox.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Masakazu Mokuno <mokuno@sm.sony.co.jp>
Subject: Re: [patch] net/ps3: Fix wireless AP connect error handling
References: <49D109B4.7020808@am.sony.com> <49F0EFB9.20709@am.sony.com> <20090424201446.GD3309@tuxdriver.com>
In-Reply-To: <20090424201446.GD3309@tuxdriver.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 04/24/2009 01:14 PM, John W. Linville wrote:
> On Thu, Apr 23, 2009 at 03:46:17PM -0700, Geoff Levand wrote:
>> From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
>> 
>> This patch fixes the bug that the driver tries to continue to
>> connect(associate) to AP even if gelic_wl_do_{wpa,wep}_setup() fails,
>> 
>> Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
>> Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
>> ---
>> Hi John,
>> 
>> I didn't see this get merged in to 2.6.30 yet.  Could you let me know the status?
>> 
>> -Geoff
> 
> I have it queued for 2.6.31.  Does it cause a crash or other problem
> serious enough to merit pushing it for 2.6.30?

I saw this was merge to Linus's tree this morning.
Here is the commit: c6dbe17f193c4adc8afc6884f26efb5fa27aa8af

Sorry for the false alarm.

-Geoff

