Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55347 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab0LAVVA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 16:21:00 -0500
Received: by bwz15 with SMTP id 15so6552464bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Dec 2010 13:20:59 -0800 (PST)
From: Holger Schurig <holgerschurig@googlemail.com>
To: "Heyendal, Carl" <CHeyendal@stanleyworks.com>
Subject: Re: wireless in linux
Date: Wed, 1 Dec 2010 22:20:52 +0100
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1D6034426110564DA0DEA9EE9793B38357E35E4823@NBE-MBX01.americas.swk.pri>
In-Reply-To: <1D6034426110564DA0DEA9EE9793B38357E35E4823@NBE-MBX01.americas.swk.pri>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012012220.53025.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I'm staring right now at the latest wpa_supplicant readme with all the
> choices that I need to make. I'll be lucky if it works. It's really been
> a piece-meal effort so far.

This has nothing to do with being a newby. Newbies use distributions. Go and 
install Fedora, SuSE, Ubuntu, whatever. They compiled wpa_supplicant for 
you.

Okay, I see that you work in the embedded space. Maybe I can point to to 
bitbake and www.openembedded.org?  Here there's a recipe that cross-compiles 
wpa_supplicant for you. While OpenEmbedded itself isn't something for 
newbies, using it takes away some of the decision-making ("Which config 
option do I need?" from you.

But I wouldn't call any embedded work a work for a newbie ...


> Are there any reference books, tutorials, howto's, wireless enabled
> kernels...anything that someone can point me to that would help?

http://wireless.kernel.org

For wpa_supplicant questions, even when it comes to compiling, try the 
hostap mailing list. This list covers both hostap and wpa_supplicant.


BTW, I agree that queries like "Linux wireless introduction" or "Linux 
wireless HOWTO" will reveal lot's of outdated stuff.

-- 
http://www.holgerschurig.de
