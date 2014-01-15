Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:56392 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaAORBi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 12:01:38 -0500
Received: by mail-ob0-f180.google.com with SMTP id wm4so1412578obc.25
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jan 2014 09:01:37 -0800 (PST)
Message-ID: <52D6BEEF.5050705@lwfinger.net> (sfid-20140115_180141_668980_A51B4613)
Date: Wed, 15 Jan 2014 11:01:35 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Olivier Langlois <olivier@trillion01.com>,
	linux-wireless@vger.kernel.org
CC: daniel@zonque.org
Subject: Re: [ISSUE] rtl8192ce appears to interfere with ALSA playback
References: <1389767820.2436.45.camel@Wailaba2>
In-Reply-To: <1389767820.2436.45.camel@Wailaba2>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/15/2014 12:37 AM, Olivier Langlois wrote:
> How to reproduce:
>
> 1. Enable Wifi while not connecting to any AP.
> 2. lano1106@hpmini ~/Music $ aplay -c1 sine.wav
> underrun!!! (at least 1856093977.967 ms long)

Olivier,

I am certain that rtl8192ce does not disable interrupts for 2 sec, but I need 
some more info from you.

What is your CPU situation? I suspect x86_64, but please confirm. How many CPUs? 
What is the maximum CPU speed?

What distro?

How do you control the wifi? Is it NetworkManager? This is important because the 
device driver does not initiate any scans on its own - scans are initiated and 
controlled by upstream.

Please provide a URL for the test file sine.wav. If it is part of your distro, 
then put it in a public repository, or E-mail it to me privately.

Larry



