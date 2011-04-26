Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nougat.ucs.ed.ac.uk ([129.215.13.205]:46237 "EHLO
	nougat.ucs.ed.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab1DZMw5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 08:52:57 -0400
Message-ID: <20110426131026.x5nnp6t24g0g48ck@www.sms.ed.ac.uk> (sfid-20110426_145300_816876_BB12BA66)
Date: Tue, 26 Apr 2011 13:10:26 +0100
From: Lito Kriara <L.Kriara@sms.ed.ac.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Mohammed Shafi <mshajakhan@atheros.com>,
	Mohammed Shajakhan <Mohammed.Shajakhan@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Add num_stations connected in debugfs
References: <1303646133-2809-1-git-send-email-mshajakhan@atheros.com>
	<1303652185.3603.0.camel@jlt3.sipsolutions.net>
	<4DB4318F.6070801@atheros.com>
	<1303657150.3603.1.camel@jlt3.sipsolutions.net>
	<4DB4415F.2070707@atheros.com>
	<1303659120.3603.3.camel@jlt3.sipsolutions.net>
	<4DB4F8D5.1060108@atheros.com>
	<20110426125801.q89ma5n6cgkwog80@www.sms.ed.ac.uk>
	<4DB6B48D.6080508@atheros.com>
	<1303819622.4784.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1303819622.4784.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok! Thank you all very much for your help!
I will try that very soon.
Lito :)



Quoting Johannes Berg <johannes@sipsolutions.net> on Tue, 26 Apr 2011  
14:07:02 +0200:

> On Tue, 2011-04-26 at 17:33 +0530, Mohammed Shafi wrote:
>> On Tuesday 26 April 2011 05:28 PM, Lito Kriara wrote:
>> > Hello,
>> > I was away the last couple of days and just saw these e-mails. It
>> > seems really interesting and helpful, but what if we need to know at
>> > runtime the number of stations connected to the AP?
>> > Is the first patch sent good to use? Should I do some modification to it?
>> >
>> Yes this will be fine.
>
> Or you can use what I wrote without patching:
>
>> >>> iw wlan0 station dump | grep '^Station ' | wc -l
>
> FWIW, I wouldn't mind adding the num_sta to debugfs, but as we discussed
> in this thread it's a different number.
>
> johannes
>
>
>



-- 
The University of Edinburgh is a charitable body, registered in
Scotland, with registration number SC005336.


