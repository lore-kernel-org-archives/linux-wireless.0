Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:51620 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204Ab2JYRLp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 13:11:45 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so1814461oag.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Oct 2012 10:11:45 -0700 (PDT)
Message-ID: <508972CD.3020004@gmail.com> (sfid-20121025_191154_172074_354C8FBD)
Date: Thu, 25 Oct 2012 11:11:41 -0600
From: Henry Ptasinski <hptasins@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Sujith Manoharan <c_manoha@qti.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	John W Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Henry Ptasinski <hptasins@gmail.com>
Subject: Re: Regression in 3.7-rc2 for b43 and b43legacy [and ath9k]
References: <50889F60.5090406@lwfinger.net> <20616.41414.398817.807498@gargle.gargle.HOWL> <5088D579.9000703@lwfinger.net>
In-Reply-To: <5088D579.9000703@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/25/2012 12:00 AM, Larry Finger wrote:
> On 10/24/2012 09:19 PM, Sujith Manoharan wrote:
>> Larry Finger wrote:
>>
>> This has been fixed:
>> https://patchwork.kernel.org/patch/1625871/
>
> That patch did the trick.

I hit the same bug with ath9k, and just finished bisecting it when I saw 
this thread.

This patch works for me also.

---
Henry Ptasinski
henry@logout.com
