Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f43.google.com ([209.85.161.43]:58110 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab0LQShZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 13:37:25 -0500
Received: by fxm18 with SMTP id 18so1019675fxm.2
        for <linux-wireless@vger.kernel.org>; Fri, 17 Dec 2010 10:37:24 -0800 (PST)
Message-ID: <4D0BADBE.40101@lwfinger.net>
Date: Fri, 17 Dec 2010 12:36:46 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Amos Blanton <amos.blanton@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8192 does not see N networks in my building
References: <AANLkTikKtc4uiXN+oHwDr8sPFXZCe3HvTfYSvgZ8uYx0@mail.gmail.com>
In-Reply-To: <AANLkTikKtc4uiXN+oHwDr8sPFXZCe3HvTfYSvgZ8uYx0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/17/2010 11:20 AM, Amos Blanton wrote:
> Greetings. I have a rtl8192 in a Strata 13 laptop from Zareason
> running Ubuntu 10.10, and I work in an environment with many Wifi
> networks. With my previous laptop I was often able to see and
> sometimes login to a local un-encrypted N network, the best we have
> around here, but this one doesn't seem to find and display that
> network via Network Manager.
> I'm told my office has cisco ap1252s running the latest 7.0 code
> release. There are B/G as well as N networks here, at least 10 that
> Network manager will recognize.
> 
> Sorry, I'm not sure what the relevant DMSG info is, so I'll include
> the latest swath. Please let me know if I should get additional info,
> and if this is the right place to report these issues.
> Thanks to everyone here who helps make Linux wireless work!

This is the right place to ask. The driver you are using is from staging, and I
don't know much about it, but let's see what we can do.

Please provide the output of the command '/sbin/lspci -nn | grep Realtek'.

In addition, please post the output of the command 'sudo /usr/sbin/iwlist scan'.
I'm guessing at the location of iwlist on your distro. If the command is not
found, then the patch is wrong - change it to match your system.

Larry
