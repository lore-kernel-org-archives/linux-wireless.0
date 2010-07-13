Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60299 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab0GMFhP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jul 2010 01:37:15 -0400
Received: by iwn7 with SMTP id 7so5474402iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jul 2010 22:37:15 -0700 (PDT)
Message-ID: <4C3BFB87.5030907@lwfinger.net>
Date: Tue, 13 Jul 2010 00:37:11 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Simon Richter <sjr@debian.org>
CC: Ben Hutchings <ben@decadent.org.uk>, Michael Buesch <mb@bu3sch.de>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org, 588196@bugs.debian.org
Subject: Re: Bug#588196: b43: does not join multicast groups
References: <20100706021937.11147.78230.reportbug@debian.hogyros.de> <1278887148.6139.91.camel@localhost> <4C3A4C6E.6060801@lwfinger.net> <20100713051430.GA2625@honey.hogyros.de>
In-Reply-To: <20100713051430.GA2625@honey.hogyros.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/13/2010 12:14 AM, Simon Richter wrote:
> Hi,
>
> On Sun, Jul 11, 2010 at 05:57:50PM -0500, Larry Finger wrote:
>
>> When you get the FATAL DMA error, the controller is reset; however,
>> that is just a simple work around that does not work on all systems.
>> To get your system to work, you need to load b43 with the following
>> options: pio=1 qos=0 nohwcrypy=1
>
> That appears to work, at least I have v6 addresses now.

Unlike before, you now have communication.

Larry
