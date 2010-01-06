Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:57534 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932740Ab0AFUab (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 15:30:31 -0500
Message-ID: <4B44F2E4.9010900@gmail.com>
Date: Wed, 06 Jan 2010 21:30:28 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: wireless, fix lock imbalance
References: <1262795743-15009-1-git-send-email-jslaby@suse.cz> <20100106195503.GB2870@tuxdriver.com>
In-Reply-To: <20100106195503.GB2870@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/06/2010 08:55 PM, John W. Linville wrote:
> On Wed, Jan 06, 2010 at 05:35:42PM +0100, Jiri Slaby wrote:
>> One fail path in cfg80211_wext_siwscan omits to unlock rdev->mtx.
>> Fix that.
>>
>> Trigerrable by "Scan for SSID" with long enough SSID (> 32).
>>
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> 
> Both this and the next one are already fixed in wireless-2.6...

Ok, thanks.
-- 
js
