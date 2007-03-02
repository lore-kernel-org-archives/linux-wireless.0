Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:57889 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161325AbXCBIZC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2007 03:25:02 -0500
Message-ID: <45E7DF58.6080608@warmcat.com>
Date: Fri, 02 Mar 2007 08:24:56 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: move PHY things to debugfs
References: <1172774065.3381.3.camel@johannes.berg>	 <45E72174.9060104@warmcat.com>  <1172775866.3381.7.camel@johannes.berg> <1172776049.3381.10.camel@johannes.berg>
In-Reply-To: <1172776049.3381.10.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2007-03-01 at 20:04 +0100, Johannes Berg wrote:
> 
>> When Greg fixes sysfs, the real way would be to follow the symlink
> 
> Oh and of course if you don't want to use sysfs then you can always use
> nl80211.

Hi Johannes -

I guess I'll stick with sysfs for now since the code is written already: 
if I will find add_iface and so on down there then I guess it will all 
work out with minor edits.

Can I ask how stable this byzantine path I am currently following to get 
a "Management interface" for tx injection is going to be?  Not even 
standard wireless ioctl but Private IOCTL SIOCIWFIRSTPRIV+0 opens out 
into a secret garden of "PRISM2" special features... is this already in 
a little black refactoring book somewhere?   Just glumly curious what 
the lifetime of any usermode code based around any of this stuff is...

-Andy
