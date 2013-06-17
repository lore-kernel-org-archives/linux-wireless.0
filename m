Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:46188 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab3FQSMX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 14:12:23 -0400
Received: by mail-oa0-f44.google.com with SMTP id l10so3857231oag.17
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2013 11:12:22 -0700 (PDT)
Message-ID: <51BF5184.1010303@lwfinger.net> (sfid-20130617_201234_388109_3CB97EE2)
Date: Mon, 17 Jun 2013 13:12:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Tobias Kluge <zielscheibe@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8192cu fail to connect with a AP
References: <loom.20130617T154136-827@post.gmane.org> <51BF2996.9060102@lwfinger.net> <loom.20130617T185506-165@post.gmane.org>
In-Reply-To: <loom.20130617T185506-165@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/17/2013 12:03 PM, Tobias Kluge wrote:
>
> compiled the latest stable kernel (3.9.6) with your fixed device table, the
> dongle is now recognized properly, when the module (rtl8192cu) is loaded.
> The connection issue to any AP still remains, with the same dmesg output. I
> don't believe that the changes you mentioned in 3.10.0-rc6 are the trouble
> makers with this device. I tried many different kernels before (3.26, 3.8.0
> binaries from the Ubuntu sources, 3.9.6, 3.10.0-rc6 build from scratch). I
> hope you can see some possibilities to fix this problem.

The changes in 3.10-rc6 *fix* many problems. They are not the source of them.

Using the wireless-testing tree, my RTL8188RU will connect to a WPA2/AES AP. It 
authenticates and associates with WPA1/TKIP and WEP APs, but there is no data 
throughput. To me this indicates a problem with the wireless keys. I have no 
idea (yet) why some chips are different than others.


Larry

