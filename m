Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46056 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758162AbaJ3JaD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2014 05:30:03 -0400
Received: by mail-wi0-f178.google.com with SMTP id q5so6796730wiv.11
        for <linux-wireless@vger.kernel.org>; Thu, 30 Oct 2014 02:30:02 -0700 (PDT)
Message-ID: <54520517.7070800@gmail.com> (sfid-20141030_103009_136491_8ACBC979)
Date: Thu, 30 Oct 2014 10:29:59 +0100
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Lubomir Rintel <lkundrak@v3.sk>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Florian Schilhabel <florian.c.schilhabel@googlemail.com>
CC: "networkmanager-list@gnome.org" <networkmanager-list@gnome.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Kernel module(r8712u) reload - suspend/resume - systemd
References: <544ECAAA.5090204@gmail.com>	 <20141027231512.GF17084@gardel-login> <544ED890.1070605@gmail.com> <1414659160.25445.0.camel@belphegor>
In-Reply-To: <1414659160.25445.0.camel@belphegor>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30.10.2014 09:52, Lubomir Rintel wrote:
> 
> On Tue, 2014-10-28 at 00:43 +0100, poma wrote:
>> On 28.10.2014 00:15, Lennart Poettering wrote:
>>> On Mon, 27.10.14 23:43, poma (pomidorabelisima@gmail.com) wrote:
>>>
>>>> but is there a better way to do it?
>>>
>>> This appears to be a kernel driver bug. Please report this issue
>>> against the kernel driver in question, systemd is not the right place
>>> to work around that.
>>>
>>> Lennart
>>>
>>
>> It's not a bug, it's a feature, just as true for the systemd. :)
>> Given the condition of the entire Linux Wireless LAN stack this can go actually.
> 
> Correct.
> 
> Moreover the driver is actually only in the staging/ ("crap") tree which
> means it has known serious quality issues and needs work. You may want
> to forward your original bug report to Larry & Florian. See [1].
> 
> [1] https://github.com/torvalds/linux/blob/master/drivers/staging/rtl8712/TODO
> 
> Lastly, please do _NOT_ cross-post to multiple unrelated mailing lists.
> The discussion then gets disconnected.
> 
> Regards,
> Lubo
> 
> 

Thanks Lubo.

[1]
TODO:
- merge Realtek's bugfixes and new features into the driver
- switch to use LIB80211
- switch to use MAC80211
- checkpatch.pl fixes - only a few remain
...

Guys, is it gonna happen?


poma

