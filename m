Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:38846 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752216AbXCQX0e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2007 19:26:34 -0400
Message-ID: <45FC7924.8050501@warmcat.com>
Date: Sat, 17 Mar 2007 23:26:28 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH 2/2] mac80211: Monitor mode radiotap-based packet injection
References: <20070317105800.659633351@warmcat.com> <200703171751.50898.flamingice@sourmilk.net> <45FC6727.3090008@warmcat.com> <200703171920.37469.flamingice@sourmilk.net>
In-Reply-To: <200703171920.37469.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Saturday 17 March 2007 18:09, Andy Green wrote:
>> Yeah naturally it was my first move to use what was there, but the
>> result was a panic that went away when I moved the skb to belong to the
>> "master" interface's index and separately persistently tagged the packet
>> as being injected.
>>
> I don't see anything that would prevent this from working.. if you have a 
> patch which does this and crashes, I'll take a look at it.

Okay I will try to regenerate this situation tomorrow afternoon, which 
will be my next chance.

-Andy
