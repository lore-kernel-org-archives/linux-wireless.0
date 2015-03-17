Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:32858 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbbCQLJn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 07:09:43 -0400
Received: by iecvj10 with SMTP id vj10so7090800iec.0
        for <linux-wireless@vger.kernel.org>; Tue, 17 Mar 2015 04:09:43 -0700 (PDT)
Date: Tue, 17 Mar 2015 07:09:39 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Dani Camps <danicamps81@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Mesh mode in ath10k
Message-ID: <20150317110939.GA21176@localhost> (sfid-20150317_121139_604900_13B32AE6)
References: <CAD3NH5W6ZetOQBAUi-2=tm+1ZA3WTHPK0xebmYAXf8zG1WhX2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAD3NH5W6ZetOQBAUi-2=tm+1ZA3WTHPK0xebmYAXf8zG1WhX2g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 14, 2015 at 08:09:27PM +0100, Dani Camps wrote:
> Dear all,
> 
> Has anyone tested mesh mode (802.11s) with ath10k? Any feedback about
> potential problems encountered and hints to resolve them is
> appreciated.

Hi Dani,

I've spent a little bit of time on it (on the order of an hour or two),
so far without success.

I can get the device to beacon with mesh beacons but have some sort
of issue adding stations and haven't had a chance to debug it.  You
will at least need the raw mode patches from here:

http://lists.infradead.org/pipermail/ath10k/2014-September/003206.html

-- 
Bob Copeland %% http://bobcopeland.com/
