Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mrs.ro ([207.192.75.59]:50396 "EHLO li37-59.members.linode.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751379AbZF3Psb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 11:48:31 -0400
Received: from localhost (localhost [127.0.0.1])
	by li37-59.members.linode.com (Postfix) with ESMTP id 5B89A794B
	for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2009 18:48:34 +0300 (EEST)
Received: from li37-59.members.linode.com ([127.0.0.1])
	by localhost (mrs.ro [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
	id HJMED8Mfk6pn for <linux-wireless@vger.kernel.org>;
	Tue, 30 Jun 2009 18:48:27 +0300 (EEST)
Received: from [192.168.0.130] (unknown [86.35.141.223])
	by li37-59.members.linode.com (Postfix) with ESMTP id AD2C9794A
	for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2009 18:48:26 +0300 (EEST)
Message-ID: <4A4A33C8.5080601@mrs.ro>
Date: Tue, 30 Jun 2009 18:48:24 +0300
From: Valentin Manea <linux-wireless@mrs.ro>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: mac80211 and broadcast frames
References: <4A49EEC3.3060108@mrs.ro>
In-Reply-To: <4A49EEC3.3060108@mrs.ro>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Again,

    I have been studying the network statistics for this problem and 
they don't really make sense to me, if I bombard the wireless device 
with broadcast packets *RX packets* in ifconfig increases very fast but 
*RX bytes* does not. However when I'm doing the same thing over the 
wired device both of them increase very fast.
    This doesn't really make sense to me, I don't understand where those 
packets are going exactly.

Thanks,
Valentin

On 06/30/2009 01:53 PM, Valentin Manea wrote:
> Hi,
>
>    I've been working on a small project that basically sends broadcast 
> UDP frames from an Wireless AP to multiple clients. While I can send 
> UDP frames just fine from the AP to the client the only a few 
> broadcast frames reach my client. What is really puzzling is that on 
> the client machine using tcpdump I can see all the broadcast frames 
> arriving, my application sees only a small fraction of them.
>
> * I have suspected some bug in the application, but the same app using 
> the same computers works fine when using wired ethernet.
> * I have used both 2.6.30 and the latest wireless-testing kernels, the 
> results are the same
> * I have used the latest hostapd in AP mode
> * I did the same tests in ad-hoc mode, the results are the same
> * I used both atheros and intel wireless cards, the problem is not 
> related to the wireless drivers.
>
> Any ideea what I'm doing wrong?
>
>
> Thanks,
> Valentin
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
