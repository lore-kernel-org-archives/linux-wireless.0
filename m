Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:35691 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbbEWFP1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 May 2015 01:15:27 -0400
Received: by oihd6 with SMTP id d6so27563639oih.2
        for <linux-wireless@vger.kernel.org>; Fri, 22 May 2015 22:15:26 -0700 (PDT)
Message-ID: <55600CEB.5080703@lwfinger.net> (sfid-20150523_071531_979317_9C810F3F)
Date: Sat, 23 May 2015 00:15:23 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?windows-1252?Q?Michael_B=FCsch?= <m@bues.ch>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: Fix EFUSE_ANA8M map value
References: <20150521214421.15983b0a@milhouse>	<555E5433.7000904@lwfinger.net>	<20150522070035.711c6195@wiggum>	<555F8FDC.3040609@lwfinger.net> <20150522231300.200a2e00@wiggum>
In-Reply-To: <20150522231300.200a2e00@wiggum>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/22/2015 04:13 PM, Michael Büsch wrote:
> On Fri, 22 May 2015 15:21:48 -0500
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> What does lsusb say about your device?
>> 7392:7811, which is an Edimax EW-7811Un
>
> It is exactly this device.
> Does yours also fail with vanilla kernel?

No, it is able to scan and connect with the vanilla kernel, but it is not 
terribly reliable with about 25% ping loss. I just got a report of a regression. 
Kernel 4.0 fails whereas 3.19 works. I have been seeing a lot of patches from 
various sources. I thought they were OK, but I will need to bisect.

Some days I am sorry that I ever heard of Linux. :)

Larry


