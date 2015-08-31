Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508AbbHaPna (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 11:43:30 -0400
Message-ID: <1441035810.2718.6.camel@redhat.com> (sfid-20150831_174350_700112_16797010)
Subject: Re: NetworkManager crashing
From: Dan Williams <dcbw@redhat.com>
To: Arend van Spriel <aspriel@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 31 Aug 2015 10:43:30 -0500
In-Reply-To: <55DF3E75.1080305@gmail.com>
References: <55DF3E75.1080305@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-08-27 at 18:44 +0200, Arend van Spriel wrote:
> Hi Dan,
> 
> I ran into issue when NetworkManager keeps crashing/respawning. I have
> no idea what happened. My laptop was rebooted (might been my sons work)
> and this was the situation I stumbled upon. Running 4.1 kernel on Linux
> Mint. NetworkManager version is 0.9.8.8.

Odd, can you get any more log messages out of the machine?  Or perhaps a
backtrace?  Looks like it's happening quite early in boot, before
anything would really get configured...

Dan

