Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:48692 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903AbZKMCJC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 21:09:02 -0500
Received: by iwn8 with SMTP id 8so2306521iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2009 18:09:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1d91afb90911121758o6109145cl23894afda8bcbee2@mail.gmail.com>
References: <1d91afb90911112231n54696c5fh950ba0102740d444@mail.gmail.com>
	<45e8e6c40911112302s7c5c3e5cq496289512410ecba@mail.gmail.com>
	<200911120847.44150.sturmflut@lieberbiber.de> <1258051444.2347.124.camel@localhost.localdomain>
	<1258051800.2347.127.camel@localhost.localdomain> <1d91afb90911121758o6109145cl23894afda8bcbee2@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 13 Nov 2009 13:08:48 +1100
Message-ID: <646765f40911121808m291a1b6amc13420e6fe384ddd@mail.gmail.com>
Subject: Re: Looking for the datasheet of zd1211rw...
To: tomas zheng <tomaswlan.zheng@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Simon Raffeiner <sturmflut@lieberbiber.de>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 13, 2009 at 12:58, tomas zheng <tomaswlan.zheng@gmail.com> wrote:
> Hi Dan and Guys,
>
> Thanks very much for your information.
> Very appreciated.
> I will try this today.
>
> But why I can not find the detail datasheet about 88W83xxxx on
> http://www.marvell.com and some googling?
> Anyone happened has it? Or , where should I go if I want it?

Given Marvell's disinterest in Linux support for older 88w83xx
chipsets, I doubt you'll be able to get it for free, let alone under
NDA.

Your best bet, if you're desperate for Linux support, is to port over
the old vendor driver to mac80211 as Dan pointed out.

Otherwise, NDISwrapper might be your friend.

Or you could do what I did when faced with a similar card, make my
other options (a rt2500pci based card) work.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
