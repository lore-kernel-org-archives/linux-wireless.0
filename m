Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:46747 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaLOUFL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2014 15:05:11 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so10272531wiv.13
        for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2014 12:05:10 -0800 (PST)
Message-ID: <548F3EF2.9020005@gmail.com> (sfid-20141215_210516_483453_2E909200)
Date: Mon, 15 Dec 2014 22:05:06 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: Jonathan Marcille <marcille.jonathan@me.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Issue with iwlwifi in Wi-Fi N mode on ThinkPad x201 (Debian Testing)
References: <548EEC55.5060804@me.com>
In-Reply-To: <548EEC55.5060804@me.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 12/15/2014 04:12 PM, Jonathan Marcille wrote:
> Hello,
> 
> I have an issue with iwlwifi driver.

What version of the kernel do you have?

> 
> I installed iwlwifi-6000-ucode-9.193.4.1 on my ThinkPad x201 (Intel® Centrino® Advanced-N 6200) running Debian Testing (Jessie)
> It works fine in b/g mode but not in N mode.
> 
> Is there something I need to do to make it work in N mode ? Or is it a driver issue with N mode ?

What do you mean by N mode?
Just the "n" being printed somewhere?
Are you sniffing the packets the device is sending and you see you don't have 11n specific data?
Are you seeing low throughput?

> 
> Thanks for the help.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
