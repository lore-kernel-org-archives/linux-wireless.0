Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36166 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab1BOOs6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 09:48:58 -0500
Received: by qyk12 with SMTP id 12so198300qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 06:48:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297294234.12795.2.camel@dev.znau.edu.ua>
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
	<AANLkTi=v9PM8pQ8qF1XpuMSYAy4=MAO2W8TQU+a3AGQn@mail.gmail.com>
	<1297288286.9734.28.camel@maggie>
	<AANLkTimS7Q5Du5_r3dZbF1gfpDofjL3Vm-AdEZP=zDQd@mail.gmail.com>
	<1297294234.12795.2.camel@dev.znau.edu.ua>
Date: Tue, 15 Feb 2011 15:48:57 +0100
Message-ID: <AANLkTi=oXNRN0Vvkn8f8-cZaEDEYqg9jUuXqBUCGhWF8@mail.gmail.com>
Subject: Re: SSB AI support code
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: George Kashperko <george@znau.edu.ua>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Uf, I'm back after weekend.

W dniu 10 lutego 2011 00:30 użytkownik George Kashperko
<george@znau.edu.ua> napisał:
>> What are the other cores for? Why do we need driver for chipcommon,
>> mipscore? Are that cores internally accessed by 80211 core?
>
> Prior to using any core, very same as b43 one, others (mipscore, usb,
> b44, etc.) must be set up properly.
> Therefore drivers exists. Chipcommon need setup as well - it handles
> cpu/mem/bus/clocks, power control, built-in uarts and might be much
> more. Its like "wrapper" core for indirect bus management.
> And I dont know if 80211 is talking directly to any other core except
> maybe chipcommon.

Thanks for explanation, but what about cores like internal memory, or
usb? What are they for?

-- 
Rafał
