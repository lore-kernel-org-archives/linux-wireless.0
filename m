Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:40890 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbZDJE3r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2009 00:29:47 -0400
Received: by fxm2 with SMTP id 2so878175fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 09 Apr 2009 21:29:45 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	reinette.chatre@intel.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] fix iwl3945 registration regression
References: <87ljqamktq.fsf@litku.valot.fi>
	<1239263762.32594.19.camel@johannes.local>
	<da94abde0904090720t3c9d5f88ta25b2b2bf71cba35@mail.gmail.com>
	<49DE0A4D.7010408@lwfinger.net> <20090409145714.GD3349@tuxdriver.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 10 Apr 2009 07:29:42 +0300
In-Reply-To: <20090409145714.GD3349@tuxdriver.com> (John W. Linville's message of "Thu\, 9 Apr 2009 10\:57\:15 -0400")
Message-ID: <877i1tuo5l.fsf@litku.valot.fi> (sfid-20090410_062949_842879_6A221991)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" <linville@tuxdriver.com> writes:

> On Thu, Apr 09, 2009 at 09:46:37AM -0500, Larry Finger wrote:
>> Kalle Valo wrote:
>
>> > Maybe this is the infamous module loading bug I see people talking
>> > about? I'll investigate it later.
>> 
>> Yes it is. The key is the "Failed to initialize wep", which is caused by a
>> failure to load modules ecb and arc4. Apply that patch and all will be well.
>
> FWIW, I reverted the problem causing commit in the master branch
> of wireless-testing.  

Nice, thanks. I have Johannes patch applied on top of latest
wireless-testing and iwl3945 works again.

-- 
Kalle Valo
