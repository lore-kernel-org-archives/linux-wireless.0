Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63131 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab1GTQbK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 12:31:10 -0400
Message-ID: <4E2702CB.9030909@lwfinger.net> (sfid-20110720_183140_011372_ED924A03)
Date: Wed, 20 Jul 2011 11:31:07 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-kernel@vger.kernel.org,
	'Chaoming_Li' <chaoming_li@realsil.com.cn>
Subject: Re: [PATCH 1/3] wireless: rtlwifi: throw away MAC_FMT and use %pM
 instead
References: <fddeabc04a1b81a5c1f51a4164d93366dccf5f8e.1311162926.git.andriy.shevchenko@linux.intel.com>	 <4E26F879.8010601@lwfinger.net> <1311177762.1663.9.camel@Joe-Laptop>
In-Reply-To: <1311177762.1663.9.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/20/2011 11:02 AM, Joe Perches wrote:
> On Wed, 2011-07-20 at 10:47 -0500, Larry Finger wrote:
>> Thanks for the patch.
>
> Hey Larry.
>
> rtlwifi has a CONFIG_BT_COEXIST which is currently
> unused/undefined by Kconfig.
>
> Are there plans to enable this or should the code
> just be removed?
>
> There may be a few dependencies in rtlwifi for
> variables set in this block so it seems from
> superficial reading that removal might be a bit
> involved.  I didn't look much more than that,
> but struct btcoexist_priv doesn't seem to be
> specified by the code anywhere.

I don't know the answer to that, but I have added Chaoming Li to the Cc. He will 
know if Realtek has any plans for BT coexistence.

Larry
