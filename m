Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:33710 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760014AbZIQDil (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 23:38:41 -0400
Message-ID: <4AB1AF38.3040601@canonical.com>
Date: Thu, 17 Sep 2009 11:38:32 +0800
From: Bryan Wu <bryan.wu@canonical.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	mb@bu3sch.de, linux-wireless@vger.kernel.org
Subject: Re: [b43] About supporting of BCM4312 [14e4:4315] with Low Power
 PHY
References: <4AA9B46E.8020100@canonical.com> <69e28c910909102318u465f6c75w46a2404a8e8d9f08@mail.gmail.com> <4AB0EDEB.9010803@canonical.com> <4AB109D7.2060300@lwfinger.net>
In-Reply-To: <4AB109D7.2060300@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> Bryan Wu wrote:
> 
>> Do you guys think it is related to 64bit DMA issue? I really want to help to develop this b43 opensource driver,
>> anything need me to do, please feel free ping me.
> 
> Not an issue with 64-bit DMA. Those people with 64-bit DMA problems
> get error messages.
> 

OK, got you. Thanks. I'm just wandering how to debug this driver. It seems that probing passes but the wlan1
interface does not work at all.

-Bryan
