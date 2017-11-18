Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:39837 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759628AbdKRPk7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Nov 2017 10:40:59 -0500
Received: by mail-oi0-f51.google.com with SMTP id r190so3594950oie.6
        for <linux-wireless@vger.kernel.org>; Sat, 18 Nov 2017 07:40:59 -0800 (PST)
Subject: Re: rtl8723be on Fedora27
To: =?UTF-8?Q?R=c3=a1kosi_Gergely?= <rakosi.gergely@gmail.com>,
        rosenp@gmail.com, linux-wireless@vger.kernel.org
References: <f5876284-360c-e6bf-01c8-ed95c4298647@gmail.com>
 <1510981609.5145.0.camel@gmail.com>
 <21a2cc76-ed4e-22a2-3eb2-1f4b8df348fd@gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <3161f550-9c7b-ecf9-45f4-2cfe4ba32d8a@lwfinger.net> (sfid-20171118_165442_642301_7A2E4C1D)
Date: Sat, 18 Nov 2017 09:40:57 -0600
MIME-Version: 1.0
In-Reply-To: <21a2cc76-ed4e-22a2-3eb2-1f4b8df348fd@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/18/2017 01:50 AM, Rákosi Gergely wrote:
> Hello,
> 
> I put in to blacklist the module rtlwifi and rtl8723be, and now I get:
> - kde's networkmanager did not recognize wireless devices
> - in the messages log there are the following :
> "registered new interface driver rtl8xxxu
> Bluetooth: hci0: rtl : Direct firmware load for
> rtl_bt/rtl8723b_config.bin failed with error -2
> - ifconfig give no wireless devices (wlp2s0 or wlan0)
> 
> If I blacklist only rtlwifi then load the rtl8723be module like normal.

That is exactly what is expected. You can ignore that missing 
rtl_bt/rtl8723b_config.bin. The BT part of the RTL8723BE does not need a 
"config.bin". A patch was sent to the BT group to get rid of that message, but 
it seems to be lost somewhere.

Larry
