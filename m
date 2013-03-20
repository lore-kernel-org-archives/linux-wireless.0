Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34423 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243Ab3CTOxb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 10:53:31 -0400
Received: by mail-ob0-f174.google.com with SMTP id 16so1693061obc.19
        for <linux-wireless@vger.kernel.org>; Wed, 20 Mar 2013 07:53:30 -0700 (PDT)
Message-ID: <5149CD68.7070603@lwfinger.net> (sfid-20130320_155338_413288_281EEF1A)
Date: Wed, 20 Mar 2013 09:53:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: isedev@gmail.com
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Michael Buesch <mb@bu3sch.de>, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] b43: A fix for DMA transmission sequence errors
References: <51421afb.xUa3KbaBuvmUk4RG%Larry.Finger@lwfinger.net> <CACna6rxAGN5cx6BXrdpM+-q_6QAQAvfb8+qhe-romE4hdxSs3g@mail.gmail.com> <514350EA.2060205@lwfinger.net> <4518745.W5blfs9sIi@wks001.ise.net>
In-Reply-To: <4518745.W5blfs9sIi@wks001.ise.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/20/2013 06:26 AM, ISE Development wrote:
>
> Did you get a chance to validate this patch?
>
> So far on my system, it has been running for over week without problems (over
> 15GB of traffic).

I have been using the patch, but I am testing rtlwifi drivers quite heavily at 
the moment, thus b43 has had limited usage. In fact, I was waiting to get a 
report from you before pushing the patch. It is ready to go.

How frequently do you get the automatic reset?

Larry


