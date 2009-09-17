Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f182.google.com ([209.85.210.182]:35403 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958AbZIQMcY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 08:32:24 -0400
Received: by yxe12 with SMTP id 12so481525yxe.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2009 05:32:28 -0700 (PDT)
Message-ID: <4AB22C59.7080703@lwfinger.net>
Date: Thu, 17 Sep 2009 07:32:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Bryan Wu <bryan.wu@canonical.com>
CC: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	mb@bu3sch.de, linux-wireless@vger.kernel.org
Subject: Re: [b43] About supporting of BCM4312 [14e4:4315] with Low Power
 PHY
References: <4AA9B46E.8020100@canonical.com> <69e28c910909102318u465f6c75w46a2404a8e8d9f08@mail.gmail.com> <4AB0EDEB.9010803@canonical.com> <4AB109D7.2060300@lwfinger.net> <4AB1AF38.3040601@canonical.com>
In-Reply-To: <4AB1AF38.3040601@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bryan Wu wrote:
> Larry Finger wrote:
>> Bryan Wu wrote:
>>
>>> Do you guys think it is related to 64bit DMA issue? I really want to help to develop this b43 opensource driver,
>>> anything need me to do, please feel free ping me.
>> Not an issue with 64-bit DMA. Those people with 64-bit DMA problems
>> get error messages.
>>
> 
> OK, got you. Thanks. I'm just wandering how to debug this driver. It seems that probing passes but the wlan1
> interface does not work at all.

Are you absolutely sure your radio switch is on? On my computer, the
driver is not reporting when the switch is off for the 4315 devices.

Larry

