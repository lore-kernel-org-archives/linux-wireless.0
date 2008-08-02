Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:36905 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750759AbYHBT1K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 15:27:10 -0400
Date: Sat, 2 Aug 2008 16:27:04 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 8/8] rfkill: add support for wake-on-wireless-packet
Message-ID: <20080802192704.GB24253@khazad-dum.debian.net> (sfid-20080802_212714_105352_38F8C5FD)
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br> <1217700664-20792-9-git-send-email-hmh@hmh.eng.br> <1217703723.8621.50.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1217703723.8621.50.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes!

On Sat, 02 Aug 2008, Johannes Berg wrote:

> On Sat, 2008-08-02 at 15:11 -0300, Henrique de Moraes Holschuh wrote:
> > Currently, rfkill would stand in the way of properly supporting wireless
> > devices that are capable of waking the system up from sleep or hibernation
> > when they receive a special wireless message.
> > 
> > Since rfkill attempts to soft-block any transmitters during class suspend,
> 
> why does it interfere with suspend anyway?

The class makes sure that all transmitters are blocked on suspend.  You'd
have to ask Ivo for the reason, but AFAIK, it is for both safety and to help
conserve power.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
