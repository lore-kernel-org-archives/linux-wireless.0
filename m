Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f43.google.com ([209.85.161.43]:36820 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172Ab0LPQD3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 11:03:29 -0500
Received: by fxm18 with SMTP id 18so3426643fxm.2
        for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 08:03:27 -0800 (PST)
Message-ID: <4D0A3849.2040709@lwfinger.net>
Date: Thu, 16 Dec 2010 10:03:21 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: convert to __packed notation
References: <1292510088-7449-1-git-send-email-linville@tuxdriver.com> <4D0A2AA8.5060808@lwfinger.net> <20101216152121.GB2413@tuxdriver.com>
In-Reply-To: <20101216152121.GB2413@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/16/2010 09:21 AM, John W. Linville wrote:
> On Thu, Dec 16, 2010 at 09:05:12AM -0600, Larry Finger wrote:
>> On 12/16/2010 08:34 AM, John W. Linville wrote:
>>> Use "__packed" instead of "__attribute__ ((packed))"...
>>>
>>> Signed-off-by: John W. Linville<linville@tuxdriver.com>
>
>> ACK.
>>
>> As a point of interest, is this the "new" recommended way? The reason I ask is
>> that the Linux headers are mostly in the attribute form.
>
> AIUI, "__packed" is the one true way.  I think this facilitates
> compling the kernel with compilers other than GCC.
>
> At any rate, Dave Miller threatened to injure me if I kept sending him stuff using
> "__attribute__ ((packed))"... :-)

We certainly would not want that. Maintainers are too hard to find.

One point I missed earlier. As you are affecting both rtlwifi and rtl8192ce, 
both should be in the patch title.

Larry
