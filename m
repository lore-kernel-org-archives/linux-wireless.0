Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:34430 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbbFUV3V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Jun 2015 17:29:21 -0400
Received: by wgqq4 with SMTP id q4so1532651wgq.1
        for <linux-wireless@vger.kernel.org>; Sun, 21 Jun 2015 14:29:20 -0700 (PDT)
Message-ID: <55872CAF.5080104@gmail.com> (sfid-20150621_232934_845772_509E65B3)
Date: Sun, 21 Jun 2015 23:29:19 +0200
From: Arend van Spriel <aspriel@gmail.com>
MIME-Version: 1.0
To: Luca Coelho <luca@coelho.fi>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH py80211 0/4] py80211: add support for scheduled scan
References: <1434117644-3033-1-git-send-email-luca@coelho.fi>	 <557BCD1C.5010408@gmail.com> <1434439990.3795.12.camel@coelho.fi>
In-Reply-To: <1434439990.3795.12.camel@coelho.fi>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 16-06-15 09:33, Luca Coelho wrote:
> Hi Arend,
> 
> On Sat, 2015-06-13 at 08:26 +0200, Arend van Spriel wrote:
>> On 12-06-15 16:00, Luca Coelho wrote:
>>> Here's a small patchset that adds support for scheduled scans in
>>> py80211.
>>
>> Thanks! One general remark. It seems you are using soft-tabs where I
>> stick to true tabs. Python is pretty anal about that so better stick to
>> true tabs.
> 
> Uh, sorry about this.  I just used what emacs does by default in
> python-mode and didn't give this much thought.  I'll make sure my future
> patches conform to pythonist tab analities. :)

No problem. I am wondering if this is common to python projects.

>>> I'm not sure this is the right approach, I added separate classes for
>>> each command, so feel free to ask me to change it completely if you
>>> want and I may or may not do it. :P
>>
>> Me neither, but it may be a bit too classy ;-) So I would prefer to have
>> a scheduled scan class with start and stop operation.
> 
> Yeah, I thought so too... In any case, I saw that you applied the classy
> version.  Shall I rework this and send new patches or shall we leave it
> as it is?

I did not have too strong opinion about it to bounce it back at you.
Let's leave it for now.

Regards,
Arend

>> Good to see you are using '_' consistently for class private members and
>> functions. I need to clean it up in other files. I recently added Pyro
>> support allowing remote access to py80211 objects and it only exposes
>> public members and functions.
> 
> Yeah, I like the idea of being strict about private versus public
> visibility.
> 
> There was a small mistake in one of the changes you made.  I'm going to
> send a fix for it in a second.
> 
> Thanks for your help!
> 
> --
> Luca.
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
