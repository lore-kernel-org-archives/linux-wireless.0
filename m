Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37352 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab0G0RaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 13:30:14 -0400
Date: Tue, 27 Jul 2010 13:18:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	David Miller <davem@davemloft.net>
Subject: Re: Confused - bisecting wireless-testing
Message-ID: <20100727171850.GD31694@tuxdriver.com>
References: <AANLkTim-0qoS7o+fcQ6uA18AC_gQSiiDe4Tv_L1FT1Ae@mail.gmail.com>
 <20100727140139.GA31694@tuxdriver.com>
 <AANLkTimS2d0jZnu-44+cbFQXvitj_3Rq3egttgOzEiRh@mail.gmail.com>
 <20100727160434.GB31694@tuxdriver.com>
 <AANLkTi=x7FzdRoC6DxeahvSm+2teN__TsoKjxphOMiPP@mail.gmail.com>
 <20100727163141.GC31694@tuxdriver.com>
 <AANLkTi=Yan5f7hcGm-GTDL=aJ_Oc-U8JExZXMZdr+MPZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTi=Yan5f7hcGm-GTDL=aJ_Oc-U8JExZXMZdr+MPZ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 27, 2010 at 09:54:20AM -0700, Luis R. Rodriguez wrote:

> So I guess the next question is where does David base his net-next.git
> off from? Will it only include 802.11 / Ethernet / Wimax / netcore /
> etc next bits or is there more? I ask to know what I'm in for in case
> I want to bisect from it or derivatives (wireless-next.git).

Generally he branches from linux-2.6 at around -rc1 (and sometimes
before) and then doesn't pull again until after the release.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
