Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43885 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab2LHWUE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2012 17:20:04 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so875403qcr.19
        for <linux-wireless@vger.kernel.org>; Sat, 08 Dec 2012 14:20:02 -0800 (PST)
Message-ID: <50C3BD0F.1050603@lwfinger.net> (sfid-20121208_232012_688045_0E245A6D)
Date: Sat, 08 Dec 2012 16:19:59 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Felix Janda <felix.janda@posteo.de>
CC: John W Linville <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT] b43: Load initial firmware file asynchronously
References: <50C01558.8050102@lwfinger.net> <20121208143032.GA1903@gauss> <50C375BE.9050907@lwfinger.net> <20121208175615.GA10664@gauss> <50C399A9.2060304@lwfinger.net> <20121208202435.GA14973@gauss> <50C3AF0C.8000607@lwfinger.net> <20121208214157.GA21034@gauss>
In-Reply-To: <20121208214157.GA21034@gauss>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/08/2012 03:41 PM, Felix Janda wrote:
> On 12/08/12 at 03:20pm, Larry Finger wrote:
>> On 12/08/2012 02:24 PM, Felix Janda wrote:
>>>
>>> Not much has changed. Say, if you want to have the complete dmesg output.
>>
>> Yes, I messed that one up. Try this one - it is different in the error recovery.
>>
>> Larry
>
> Now I have a wlan0. Haven't tested it though yet. dmesg still prints some errors.

That is not an error - I just left a diagnostic in the code. Please let me know 
if it works. It should as we only touched the firmware loading.

Is it OK if I use a "Reported-and-Tested by: <you>?

Larry


