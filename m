Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:42020 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaIZM6Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2014 08:58:24 -0400
Received: by mail-ob0-f169.google.com with SMTP id uy5so7296320obc.0
        for <linux-wireless@vger.kernel.org>; Fri, 26 Sep 2014 05:58:24 -0700 (PDT)
Date: Fri, 26 Sep 2014 07:58:12 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Keno =?utf-8?Q?Br=C3=BCggemann?= <post@kenobrueggemann.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Ubuntu 14.04 and the =?utf-8?Q?Intel?=
 =?utf-8?B?wq4gQ2VudHJpbm/Crg==?= Advanced-N 6200
Message-ID: <20140926125812.GA138943@ubuntu-hedt> (sfid-20140926_145827_801556_069C90C7)
References: <542470A1.5070406@kenobrueggemann.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <542470A1.5070406@kenobrueggemann.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 25, 2014 at 09:44:33PM +0200, Keno Brüggemann wrote:
> Hello,
> 
> i switched from an Intel® Centrino® Wireless-N 1000
> to the Intel® Centrino® Advanced-N 6200 Wireless Card Adapter.
> 
> My System. Dell xps l701x, ubuntu 14.04
> 
> The Problem is, this Adpater won't work under Ubuntu 14.04. I've
> installed both versions of this Firmware.
> Nothing. Seems to be dead.
> Under Windows 7 the Card works well.
> 
> Can i try something else to get it work?
> Please help.

It certainly ought to work, there are plenty of people using Intel 6200
hardware with Ubuntu 14.04.

A few pieces of information would be useful to start - the output of
'lspci -nn', dmesg, and whether or not the iwlwifi and iwldvm modules
are loaded (i.e. are they listed in the output from lsmod).

Or you might just want to file a bug against Ubuntu by running
'ubuntu-bug linux' while on a wired connection. This will automatically
attach all the information I just asked for to the bug report. You can
subscribe me to the bug and I'll help you out there.

Thanks,
Seth

