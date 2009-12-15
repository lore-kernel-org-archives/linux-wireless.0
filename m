Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f211.google.com ([209.85.217.211]:55157 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759037AbZLOCzx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 21:55:53 -0500
Received: by gxk3 with SMTP id 3so5294142gxk.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2009 18:55:53 -0800 (PST)
Message-ID: <4B26F985.7010906@lwfinger.net>
Date: Mon, 14 Dec 2009 20:50:45 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ahmad Yasser <ahmad.xcoder@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Does the RTL8187 mac80211 drivers support master/ap mode?
References: <loom.20091215T030930-675@post.gmane.org> <4B26F38B.6080406@lwfinger.net> <loom.20091215T033724-246@post.gmane.org>
In-Reply-To: <loom.20091215T033724-246@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/14/2009 08:38 PM, Ahmad Yasser wrote:
> Larry Finger <Larry.Finger@...> writes:
>>
>> It does not work in master/ap mode. It is on my list, but it will
>> certainly not be in 2.6.33, which is feature frozen. It may not even
>> make it for 2.6.34.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@...
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
> 
> Oh, sad to hear so.. :/
> 
> So is there any other solution to using hostapd with it, or
> I just have to wait for the driver to gain support for it?

It cannot handle generating beacons. You can figure out the answer
from there.
