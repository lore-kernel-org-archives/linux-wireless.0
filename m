Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756753Ab2AXOjg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 09:39:36 -0500
Date: Tue, 24 Jan 2012 15:39:10 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Andreas Hartmann <andihartmann@01019freenet.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: Compat-wireless-3.2-rc6-3 is broken for rt2860 device
Message-ID: <20120124143909.GA5217@redhat.com> (sfid-20120124_153939_887046_CB12657A)
References: <4F0AEBAB.9020104@01019freenet.de>
 <CAGXE3d-cOeTEHugbgWMoz8-Dymw0=JHxykdK4ZkBmCJZ9tSPmg@mail.gmail.com>
 <201201100803.q0A83nsQ003757@mail.maya.org>
 <CAGXE3d_jW7NFnekMfwn6JPXX0xB4UWM3ttbRVLv-ZbsoMOoWEw@mail.gmail.com>
 <201201200730.q0K7U0oj004966@mail.maya.org>
 <CAGXE3d_rCMYwoEBNjk+S7WvAmCkPMcq-Gpawm370-cSbjXy6rg@mail.gmail.com>
 <4F1D84CE.8020403@maya.org>
 <CAGXE3d_UPmcjgss+xMPBtkM22kBwGD23y8Fzxkr+6286W+EwbQ@mail.gmail.com>
 <201201231744.q0NHi68I002597@mail.maya.org>
 <CAGXE3d8P0UjnZ7Z=gg1uoe0WUX+4jWmg=a2i9_nV5E6i-xcfLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGXE3d8P0UjnZ7Z=gg1uoe0WUX+4jWmg=a2i9_nV5E6i-xcfLQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 24, 2012 at 09:07:04AM +0100, Helmut Schaa wrote:
> > but the machine does crash anyway. Could hdr be null, too?
> 
> Ok, I'll do some testing as soon as time allows and get back to you then.

Not sure how good idea is is, but perhaps we could introduce mac80211 flag
that will disable behaviour of f0425bed commit for drivers, which will
set that flag.

Stanislaw
