Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39604 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760188Ab0I0U02 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 16:26:28 -0400
Received: by qwh6 with SMTP id 6so3604683qwh.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 13:26:28 -0700 (PDT)
Subject: Re: Question about starting up an AP
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Joshua Smith <jesmith@kaon.com>
In-Reply-To: <201009272143.52283.helmut.schaa@googlemail.com>
Date: Mon, 27 Sep 2010 16:26:21 -0400
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Message-Id: <EA2A527E-E8DA-4612-B8CB-518E2C6BA7D2@kaon.com>
References: <DA0C92FD-F6BF-4746-9BE1-A643A0D70F7A@kaon.com> <201009271956.41041.helmut.schaa@googlemail.com> <D83E9C0C-C35C-4787-832E-1308213F325E@kaon.com> <201009272143.52283.helmut.schaa@googlemail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sep 27, 2010, at 3:43 PM, Helmut Schaa wrote:

> Am Montag 27 September 2010 schrieb Joshua Smith: 
>> I have another problem with these cards and hostapd where occasionally they
>> will send a beacon but not respond to clients trying to join the network. 
>> However, stopping hostapd and restarting it clears this condition.
> 
> Most likely a stuck tx queue. Do you have 11n enabled?

No.  My hostapd has:

hw_mode=a

Is that consistent or inconsistent with your stuck tx queue theory?

> 
> A fix to make the tx queue not stuck anymore (at least on rt3052 SoC) is
> already in rt2x00 git [1] and [2]. However, I'm not sure if this is the same
> issue you're facing.

Would things "already in rt2x00 git" be in the compat-wireless bleeding edge tarball?

> 
> Helmut
> 
> [1] http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=4758f8c3686911ecff11f39508a60327d42893df
> [2] http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=0402943d65e6832ba1cd88621d79c0c83a23ddeb

