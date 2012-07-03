Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:35890 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab2GCQqg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 12:46:36 -0400
Received: by qcro28 with SMTP id o28so3776256qcr.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jul 2012 09:46:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6VPpP55jF9Jz2aftK7isLj1X1kCZnHSB8tBe4TFyiHqew@mail.gmail.com>
References: <E50901D4F2CF69428D43141B7C85867929E154AE7B@EXMB03.eu.tieto.com>
	<CAMcMvsioAY3sZZ77gu1MwHi5hcq4D71SAVSHYh3m=bYiWAXSqg@mail.gmail.com>
	<CAB=NE6VPpP55jF9Jz2aftK7isLj1X1kCZnHSB8tBe4TFyiHqew@mail.gmail.com>
Date: Tue, 3 Jul 2012 09:46:33 -0700
Message-ID: <CAMcMvsgo+GV7Cky8K=QAX1Q1_BKF7axMX29gYZ8jZYTN5kLAYg@mail.gmail.com> (sfid-20120703_184645_826092_3879970A)
Subject: Re: wlan automated tests
From: Paul Stewart <pstew@chromium.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Piotr.Nakraszewicz@tieto.com, linux-wireless@vger.kernel.org,
	filip.matusiak@tieto.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 3, 2012 at 9:11 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Tue, Jul 3, 2012 at 8:54 AM, Paul Stewart <pstew@chromium.org> wrote:
>> On Tue, Jul 3, 2012 at 5:47 AM,  <Piotr.Nakraszewicz@tieto.com> wrote:
>>> Hi,
>>>
>>> What is the current status of wlan automated tests?
>>>
>>> I found 3 started projects:
>>>
>>> 1. wifi-test:
>>> http://wireless.kernel.org/en/developers/Testing/wifi-test
>>> But it looks dead. Last commit is from 2010.
>>>
>>> 2. LTP:
>>> http://thread.gmane.org/gmane.linux.kernel.wireless.general/19759
>>> http://thread.gmane.org/gmane.linux.ltp/7884
>>>
>>> The last comment I found was from 2009 from Luis R. Rodriguez:
>>> "The GSoC student fell off from the face of the earth without even notice so the project was never finished. The project is up for grabs for anyone now to implement."
>>>
>>> Is that still valid?
>>>
>>> 3. Chromium Wifi tests:
>>> http://thread.gmane.org/gmane.linux.kernel.wireless.general/57576
>>>
>>> The problem is they are designed to test chromium OS so it looks like they can't be used for purpose described here:
>>
>> It should be reasonably straightforward to use this setup with
>> something other than ChromeOS.  Most of the work required to do so
>> would circle around creating platform-specific routines used to
>> establish and monitor status of connections -- the
>> site_wlan_connect.py and site_wlan_wait_state.py scripts.
>
> That's pretty awesome, what is the source of documentation for this?
> Is code pushed back upstream to autotest now ?

There's not a whole lot of documentation floating around externally,
however that should change fairly soon.  Since, as you say, this stuff
is fairly customized for ChromeOS as-is, no effort has been made to
push the core of the WiFi tests upstream.

>
>   Luis
