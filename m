Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:23991 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090AbZKEE56 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 23:57:58 -0500
Received: by qw-out-2122.google.com with SMTP id 9so1674885qwb.37
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2009 20:58:03 -0800 (PST)
Message-ID: <4AF25B53.3090204@gmail.com>
Date: Wed, 04 Nov 2009 23:57:55 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org, mcgrof@gmail.com,
	johannes@sipsolutions.net
Subject: Re: [PATCH] rtl8187: Fix kernel oops when device is removed when
 LEDS enabled (Bugzilla #14539)
References: <4af11879./IumKJ+RAbw7Zkq6%Larry.Finger@lwfinger.net> <20091104151132.GD12965@tuxdriver.com> <4AF1A3BD.1020009@lwfinger.net> <20091104165453.GH12965@tuxdriver.com> <4AF1C42E.7000808@lwfinger.net> <20091104184700.GK12965@tuxdriver.com>
In-Reply-To: <20091104184700.GK12965@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Wed, Nov 04, 2009 at 12:13:02PM -0600, Larry Finger wrote:
>   
>> On 11/04/2009 10:54 AM, John W. Linville wrote:
>>     
>>> On Wed, Nov 04, 2009 at 09:54:37AM -0600, Larry Finger wrote:
>>>
>>>       
>>>> I will try once more to get netconsole working to capture the backtrace.
>>>>         
>>> No need, I think I understand it now.  The new order still sorta
>>> looks/feels "wrong", but it seems fine.  Maybe an alternative would
>>> be to make the brightness_set routine aware of the shutdown and not
>>> queue the work?  Maybe even ieee80211_queue_delayed_work could be
>>> made a bit smarter here?
>>>       
>> Are either of these questions a request, or are they musings?
>>     
>
> They are musings -- but feel free to be inspired! :-)
>
>   
I can't speak for "proper coding style" or "preferred fixes" or whatever 
you awesome coders call things, but I can say that myself and a few 
others have extensively test _this_ fix and can no longer crash the 
kernel.  As the original reporter I am more than satisfied that this is 
fixed.  Just my 0.02$

Thanks,
Rick Farina

