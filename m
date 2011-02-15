Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:10351 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061Ab1BOPBc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 10:01:32 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000021563.msg
	for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 17:00:50 +0200
Subject: Re: SSB AI support code
From: George Kashperko <george@znau.edu.ua>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTi=oXNRN0Vvkn8f8-cZaEDEYqg9jUuXqBUCGhWF8@mail.gmail.com>
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
	 <AANLkTi=v9PM8pQ8qF1XpuMSYAy4=MAO2W8TQU+a3AGQn@mail.gmail.com>
	 <1297288286.9734.28.camel@maggie>
	 <AANLkTimS7Q5Du5_r3dZbF1gfpDofjL3Vm-AdEZP=zDQd@mail.gmail.com>
	 <1297294234.12795.2.camel@dev.znau.edu.ua>
	 <AANLkTi=oXNRN0Vvkn8f8-cZaEDEYqg9jUuXqBUCGhWF8@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 15 Feb 2011 16:53:16 +0200
Message-Id: <1297781596.29066.3.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Uf, I'm back after weekend.
> 
> W dniu 10 lutego 2011 00:30 użytkownik George Kashperko
> <george@znau.edu.ua> napisał:
> >> What are the other cores for? Why do we need driver for chipcommon,
> >> mipscore? Are that cores internally accessed by 80211 core?
> >
> > Prior to using any core, very same as b43 one, others (mipscore, usb,
> > b44, etc.) must be set up properly.
> > Therefore drivers exists. Chipcommon need setup as well - it handles
> > cpu/mem/bus/clocks, power control, built-in uarts and might be much
> > more. Its like "wrapper" core for indirect bus management.
> > And I dont know if 80211 is talking directly to any other core except
> > maybe chipcommon.
> 
> Thanks for explanation, but what about cores like internal memory, or
> usb? What are they for?
> 
As for internal memory core dont really know. There is some asm magic in
Broadcom's code to set timings and maybe something else but I've never
looked it in depth, maybe some day later.
And usb core, well, its interface to usb host controller.

Have nice day,
George


