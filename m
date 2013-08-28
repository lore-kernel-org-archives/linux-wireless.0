Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from soto.provo.novell.com ([137.65.250.214]:48508 "EHLO
	soto.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab3H1JFM convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:2:1>);
	Wed, 28 Aug 2013 05:05:12 -0400
Message-Id: <521E49E30200009200026772@soto.provo.novell.com> (sfid-20130828_110520_134155_07E02F44)
Date: Wed, 28 Aug 2013 03:05:07 -0600
From: "Matt Chen" <machen@suse.com>
To: <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: NGFF based WLAN module
References: <521E16F50200009200026750@soto.provo.novell.com>
 (sfid-20130828_072756_206141_92BC02A8)
 <1377672233.13797.4.camel@jlt4.sipsolutions.net>
In-Reply-To: <1377672233.13797.4.camel@jlt4.sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>>> Johannes Berg  08/28/13 2:44 PM >>>
On Tue, 2013-08-27 at 23:27 -0600, Matt Chen wrote:
>> Hi,
>> 
>> 
>> 
>> I have a NGFF WLAN module, Intel Wilkins Peak 2, I am wondering how to =
> >
>> enable it. I found there is nothing from the lspci result. Is there any =
>> 
>> way to enable it in Linux ?

>It should just be a regular PCIe device afaik, so maybe there's
>something wrong with your system?

>johannes

As document described,  it is SDIO. No idea how to enable it. 


--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



