Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:37520 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab0CTWfZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Mar 2010 18:35:25 -0400
Received: by qyk9 with SMTP id 9so2536269qyk.1
        for <linux-wireless@vger.kernel.org>; Sat, 20 Mar 2010 15:35:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <cdc21431003201534i5a10c871m1a76aba4f254345f@mail.gmail.com>
References: <cdc21431003201534i5a10c871m1a76aba4f254345f@mail.gmail.com>
Date: Sat, 20 Mar 2010 17:35:23 -0500
Message-ID: <cdc21431003201535g40854df4ged9afd948660be19@mail.gmail.com>
Subject: Re: Automated way of swipping in and out modules?
From: Rakesh Kumar <gopchandani@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hello Folks,
> So I have been hacking at cfg80211 and everytime I modify it, I have to rmmod all the dependent modules' tree on the top of it and then insert my newly modified module using insmod and then modprobe all the previously installed, dependent modules.
> I was wondering if there is a faster way, which I am not aware of, to do this besides writing an script? If you have a working script, I would appreciate that too. :)
> --
> Rakesh
