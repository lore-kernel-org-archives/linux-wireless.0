Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:54965 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbYHLVyp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2008 17:54:45 -0400
Received: by nf-out-0910.google.com with SMTP id d3so960918nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 12 Aug 2008 14:54:44 -0700 (PDT)
Message-ID: <48A206A0.6020709@gmail.com> (sfid-20080812_235452_545788_C046D9F3)
Date: Wed, 13 Aug 2008 00:54:40 +0300
From: Maxim Levitsky <maximlevitsky@gmail.com>
MIME-Version: 1.0
To: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: [ipw3945-devel] Few questions about the wireless stack
References: <48A07709.80306@gmail.com>
In-Reply-To: <48A07709.80306@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maxim Levitsky wrote:
> Hi,
> 
> I am trying to understand the relationship between
> wireless interfaces (wlan0, mon0,..) and wireless driver.
> 
> The most important question I am after, is what types of interfaces I can
> run simultaneously? 
> (I know that I can run station and monitor, but what are other  combinations ?)
> 
> I noticed that in monitor mode iwl3945 appends so called 
> 'radiotap' header to received packets, but
> it seems that mac80211 strips this header, and appends its own,
> for monitor interfaces, if so, then why to append it?
> 
> 
> And lastly, when you expect AP code to be released?
> 

I would be glad to hear about this, I have absolutely no free time to dig that out.


Maxim Levitsky
