Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38822 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab2GCQLr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 12:11:47 -0400
Received: by yhmm54 with SMTP id m54so6242204yhm.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jul 2012 09:11:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMcMvsioAY3sZZ77gu1MwHi5hcq4D71SAVSHYh3m=bYiWAXSqg@mail.gmail.com>
References: <E50901D4F2CF69428D43141B7C85867929E154AE7B@EXMB03.eu.tieto.com> <CAMcMvsioAY3sZZ77gu1MwHi5hcq4D71SAVSHYh3m=bYiWAXSqg@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 3 Jul 2012 09:11:25 -0700
Message-ID: <CAB=NE6VPpP55jF9Jz2aftK7isLj1X1kCZnHSB8tBe4TFyiHqew@mail.gmail.com> (sfid-20120703_181150_782359_08539A07)
Subject: Re: wlan automated tests
To: Paul Stewart <pstew@chromium.org>
Cc: Piotr.Nakraszewicz@tieto.com, linux-wireless@vger.kernel.org,
	filip.matusiak@tieto.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 3, 2012 at 8:54 AM, Paul Stewart <pstew@chromium.org> wrote:
> On Tue, Jul 3, 2012 at 5:47 AM,  <Piotr.Nakraszewicz@tieto.com> wrote:
>> Hi,
>>
>> What is the current status of wlan automated tests?
>>
>> I found 3 started projects:
>>
>> 1. wifi-test:
>> http://wireless.kernel.org/en/developers/Testing/wifi-test
>> But it looks dead. Last commit is from 2010.
>>
>> 2. LTP:
>> http://thread.gmane.org/gmane.linux.kernel.wireless.general/19759
>> http://thread.gmane.org/gmane.linux.ltp/7884
>>
>> The last comment I found was from 2009 from Luis R. Rodriguez:
>> "The GSoC student fell off from the face of the earth without even notice so the project was never finished. The project is up for grabs for anyone now to implement."
>>
>> Is that still valid?
>>
>> 3. Chromium Wifi tests:
>> http://thread.gmane.org/gmane.linux.kernel.wireless.general/57576
>>
>> The problem is they are designed to test chromium OS so it looks like they can't be used for purpose described here:
>
> It should be reasonably straightforward to use this setup with
> something other than ChromeOS.  Most of the work required to do so
> would circle around creating platform-specific routines used to
> establish and monitor status of connections -- the
> site_wlan_connect.py and site_wlan_wait_state.py scripts.

That's pretty awesome, what is the source of documentation for this?
Is code pushed back upstream to autotest now ?

  Luis
