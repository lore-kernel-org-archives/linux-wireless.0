Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost06.isp.att.net ([204.127.217.106]:64649 "EHLO
	fmailhost06.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007AbZCYDIY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 23:08:24 -0400
Message-ID: <49C99FF8.6090509@lwfinger.net> (sfid-20090325_040827_124503_831F8655)
Date: Tue, 24 Mar 2009 22:07:36 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "RuXu W." <wrxzzj@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: b43 make kernel 2.6.29 crashed, help!
References: <737c90be0903240006q2066c53bl1ce50eadd45e893b@mail.gmail.com>	 <49C8F476.5070500@lwfinger.net> <737c90be0903241851kc948f39q2cd9502a35c4c3ac@mail.gmail.com>
In-Reply-To: <737c90be0903241851kc948f39q2cd9502a35c4c3ac@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RuXu W. wrote:
> Thanks for you reply.
> 2.6.29 downloaded from release ftp server.
> 
> Larry, should I download source from vanilla branch  and build it ?

OK, you have a vanilla 2.6.29. I do not believe that you are seeing a b43
problem. If I had the problem, I would download the git tree and build it. If it
also fails, you would be able to bisect the problem. What is the latest version
that you built that worked? Did you try any of the 2.6.29-rcX versions?

Larry
