Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60485 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2DPWcA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 18:32:00 -0400
Received: by iagz16 with SMTP id z16so8032761iag.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 Apr 2012 15:31:59 -0700 (PDT)
Message-ID: <4F8C9DDD.5080704@lwfinger.net> (sfid-20120417_003203_346282_4497F5E6)
Date: Mon, 16 Apr 2012 17:31:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: spams@ivanich.org.ua
CC: linux-wireless@vger.kernel.org
Subject: Re: Regression in kernel-3.4-rcx with rtl8192ce
References: <2054318.iQACctbcH2@ivanich.org.ua>
In-Reply-To: <2054318.iQACctbcH2@ivanich.org.ua>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/16/2012 04:52 PM, spams@ivanich.org.ua wrote:
> I'm using rtl8188ce in AP mode with hostapd, after upgrade to 3.4-rcx
> kernel(tried 3.4-rc2,rc3 and latest source from wireless-next.git) I can't
> connect to my AP.
> AP Log:
> Apr 16 23:31:39 localhost hostapd: wlan0: STA d8:b3:cf:d1:a0:58 IEEE 802.11:
> authenticated
> Apr 16 23:31:39 localhost hostapd: wlan0: STA d8:b3:cf:d1:a0:58 IEEE 802.11:
> Station sent an invalid association request
>
> Tried disabling and enabling different options in hostapd.conf but with no
> luck. With kernels-3.3.x it works just fine.
> Thank you.

Please bisect this using the wireless-testing git source. From what I remember, 
there are no changes in the rtlwifi/rtl8192c/rtl8192ce that should affect this 
situation.

Larry

