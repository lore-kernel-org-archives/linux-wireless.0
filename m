Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost03.isp.att.net ([207.115.11.53]:38092 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbZDDSXb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Apr 2009 14:23:31 -0400
Message-ID: <49D7A599.5070306@lwfinger.net> (sfid-20090404_202439_286626_E75AEC67)
Date: Sat, 04 Apr 2009 13:23:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hamlet <h@mlet.me>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] rtl8187: Improve wireless statistics for RTL8187
References: <49375ac0.z1uZDBLv3IxmmMgD%Larry.Finger@lwfinger.net>	 <69e28c910812040444l5d76632ah288078bd3db172d4@mail.gmail.com>	 <200812041357.00103.chunkeey@web.de> <69e28c910812040514l2d325eeekef3decbcce2520b2@mail.gmail.com> <4937E3DF.4030407@lwfinger.net> <loom.20090404T180348-423@post.gmane.org>
In-Reply-To: <loom.20090404T180348-423@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hamlet wrote:
> Larry Finger <Larry.Finger@...> writes:
> 
>> Is it possible for you to send me the quality and signal strength that you
>> obtain for the RTL8187 at distances of a few cm, 3m and 10m from the AP? Please
>> include which algorithm was used in the conversion.
> 
> Hello.
> I really new to that, but I would be glad to help !
> I had big troubles with vanilla kernel drivers, but that's not news.
> I'm currently compiling compat-wireless-2009-04-04 and I hope results will be
> better.
> 
> My device :
> Bus 001 Device 004: ID 0bda:8187 Realtek Semiconductor Corp. RTL8187 Wireless
> Adapter
> 
> It's on a laptop so I can do every kind of test you can imagine ! ;-)
> 
> Regards,
> Hamlet
> 
> PS. Please reply to my address since I'm not on the mailing-list...
> Tell me if you think I should !

Since I requested that data, I got my own RTL8187L and filled in the data.
Compat-wireless has the latest version of the driver. In addition, the latest
version of mac80211 no longer needs that information, and calculates its own
signal strength and link quality.

The only test that you need to do is check that the rate is automatically
adjusted up from 1 Mb/s. Some flavors of RTL8187L's seem to have a problem in
setting the rate. Mine does not.

Larry
