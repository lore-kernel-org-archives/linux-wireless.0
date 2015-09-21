Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:34456 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbbIUQic (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 12:38:32 -0400
Received: by oiev17 with SMTP id v17so61128636oie.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2015 09:38:32 -0700 (PDT)
Subject: Re: [PATCH][RFC][RFT] ssb: pick PCMCIA host code support from b43
 driver
To: =?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>
References: <1442826259-6270-1-git-send-email-zajec5@gmail.com>
 <56002CE8.3080605@lwfinger.net> <20150921182622.0727f224@wiggum>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	b43-dev@lists.infradead.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <56003286.4010800@lwfinger.net> (sfid-20150921_183835_897091_BA258B37)
Date: Mon, 21 Sep 2015 11:38:30 -0500
MIME-Version: 1.0
In-Reply-To: <20150921182622.0727f224@wiggum>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/21/2015 11:26 AM, Michael Büsch wrote:
> On Mon, 21 Sep 2015 11:14:32 -0500
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
>> This patch has been tested on PPC architecture with Linksys WPC54G PCMCIA cards.
>
> Are you sure that this really is a 16 bit PCMCIA card and not a PC-Card?
> If it shows up in lspci, it's not a PCMCIA card.

Point taken. These are indeed PC-Cards in a PCMCIA format.

>> It probably does not matter here, but I prefer that hexadecimal constants in
>> device tables contain only the lower-case versions of a-f. That makes searching
>> for such constants with grep a lot easier.
>
> I prefer coffee over tea. That doesn't make coffee any better, though.
>
> Is it really so that the rest of the kernel only uses lower case here?
> Grep also supports case insensitive regexes, if done correctly. And if
> not everybody uses lower case here, you'll have to do that anyway.

Yes, I know how to use grep to ignore case.

Larry

>

