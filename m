Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755AbbHaSPJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 14:15:09 -0400
Message-ID: <1441044908.2718.20.camel@redhat.com> (sfid-20150831_201513_540417_19B2F8FC)
Subject: Re: NetworkManager crashing
From: Dan Williams <dcbw@redhat.com>
To: Arend van Spriel <aspriel@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 31 Aug 2015 13:15:08 -0500
In-Reply-To: <55E49334.5000103@gmail.com>
References: <55DF3E75.1080305@gmail.com>
	 <1441035810.2718.6.camel@redhat.com> <55E49334.5000103@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-08-31 at 19:47 +0200, Arend van Spriel wrote:
> 
> On 31-08-15 17:43, Dan Williams wrote:
> > On Thu, 2015-08-27 at 18:44 +0200, Arend van Spriel wrote:
> >> Hi Dan,
> >>
> >> I ran into issue when NetworkManager keeps crashing/respawning. I have
> >> no idea what happened. My laptop was rebooted (might been my sons work)
> >> and this was the situation I stumbled upon. Running 4.1 kernel on Linux
> >> Mint. NetworkManager version is 0.9.8.8.
> > 
> > Odd, can you get any more log messages out of the machine?  Or perhaps a
> > backtrace?  Looks like it's happening quite early in boot, before
> > anything would really get configured...
> 
> Yikes. My mistake. I have two libnl-3 versions installed and
> NetworkManager loaded the wrong one. Doing walk of shame here.

Yeah, that'll do it...  glad to see it got figured out.

Dan

