Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from leit.jelmoni.net ([78.46.129.73]:37494 "EHLO leit.jelmoni.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870Ab3BRNRt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 08:17:49 -0500
Received: from localhost (localhost.jelmoni.net [127.0.0.1])
	by leit.jelmoni.net (Postfix) with ESMTP id 3E9CA80D2
	for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2013 14:17:48 +0100 (CET)
Received: from leit.jelmoni.net ([127.0.0.1])
	by localhost (leit.jelmoni.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CpfR9zYtf1VP for <linux-wireless@vger.kernel.org>;
	Mon, 18 Feb 2013 14:17:48 +0100 (CET)
Received: from laptop-beat.swiss-wireless.com.ar (host126.190-224-81.telecom.net.ar [190.224.81.126])
	(Authenticated sender: genauth@swiss-wireless.com.ar)
	by leit.jelmoni.net (Postfix) with ESMTPSA id 6101480D1
	for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2013 14:17:47 +0100 (CET)
Message-ID: <512229DD.80901@swiss-wireless.com.ar> (sfid-20130218_141753_646520_3D9B381F)
Date: Mon, 18 Feb 2013 10:17:17 -0300
From: Beat Meier <mbe_ml@swiss-wireless.com.ar>
MIME-Version: 1.0
To: Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: How can I find out the ssid of an inteface in AP mode?
References: <511D3AA4.7000209@swiss-wireless.com.ar> <201302142053.57519.chunkeey@googlemail.com>
In-Reply-To: <201302142053.57519.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/14/2013 04:53 PM, Christian Lamparter wrote:
> On Thursday, February 14, 2013 08:27:32 PM Beat Meier wrote:
>> Hello
>>
>> How can I find out the ssid of an inteface in AP mode (using hostapd)?
> start up hostapd_cli
>
> (usually it connects to the right wlanX interface, otherwise
> execute interface wlanX)
>
> get_config
>
> (And then look for ssid=xyz)
Ah ok, thanks a lot Christian! This points me to te right way. My 
hostapd on voyage is outdated...
In version 0.7.3 this is not implemented... So I will updated as soon as 
possible.
Thanks again!

Beat
