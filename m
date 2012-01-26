Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59089 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab2AZXun (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 18:50:43 -0500
Received: by ggnb1 with SMTP id b1so571882ggn.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 15:50:42 -0800 (PST)
Message-ID: <4F21E6CF.5040006@lwfinger.net> (sfid-20120127_005046_736539_B98D147E)
Date: Thu, 26 Jan 2012 17:50:39 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>
CC: Chaoming Li <chaoming_li@realsil.com.cn>,
	Tim Gardner <tim.gardner@canonical.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Problems associating with RTL8188CE
References: <4EE7B85E.3070802@lwfinger.net> <20111213212606.GB30788@thinkpad-t410> <4EE82CC6.2030307@lwfinger.net> <20111214162333.GB19410@thinkpad-t410> <4EE8D150.8090100@lwfinger.net> <20111214164902.GD19410@thinkpad-t410> <4EE8D5A1.7040600@lwfinger.net> <20111214171234.GE19410@thinkpad-t410> <4EE8E035.90501@lwfinger.net> <20111214175804.GG19410@thinkpad-t410> <20120126213344.GC14465@ubuntu-macmini>
In-Reply-To: <20120126213344.GC14465@ubuntu-macmini>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/2012 03:33 PM, Seth Forshee wrote:
> Sorry for the long silence on this, I was busy with some other things.
> But I've been playing with it again this week and uncovered some new
> information regarding the failures.
>
> I noticed the other day that the rtl8188ce was no longer having trouble
> associating with this AP. After playing around in the router settings I
> discovered that it works fine so long as the router isn't on channel 1.
> So then I configured my other router to use channel 1, and then I
> started seeing problems with that router as well.
>
> I also tried the rtl8192ce driver from Realtek's website, and I'm having
> better luck with that driver.

Seth,

Are those AP's 802.11n devices that allow HT features on channel 1? I do not 
know if we support that or not. On my 802.11n device, it automatically switches 
to channel 3 when I enable HT, and that works.

I can connect to an 802.11g AP on channel 1 with no trouble.

Larry

