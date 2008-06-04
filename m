Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52295 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752548AbYFDDjE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 23:39:04 -0400
Date: Wed, 4 Jun 2008 00:39:00 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Roskin <proski@gnu.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH 01/12] rfkill: clarify meaning of rfkill states
Message-ID: <20080604033900.GA30978@khazad-dum.debian.net> (sfid-20080604_053909_464280_15812001)
References: <1212549017-30144-1-git-send-email-hmh@hmh.eng.br> <1212549017-30144-2-git-send-email-hmh@hmh.eng.br> <20080603233202.2ysgs5s9n4cww4s4-cebfxv@webmail.spamcop.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080603233202.2ysgs5s9n4cww4s4-cebfxv@webmail.spamcop.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 03 Jun 2008, Pavel Roskin wrote:
> Quoting Henrique de Moraes Holschuh <hmh@hmh.eng.br>:
>
>> rfkill really should have been named rfswitch.
>
> I hope it's not too late to rename.  If it's planned in advance and the 
> related userspace utilities are given an advance notice, it should go 
> smoothly.  Linux went through bigger changes.

Well, after this patch set, it is properly documented enough that people
won't get confused by the inverted logic.  And rfswitch would still
cause the same confusion re. input devices, so it wouldn't help much
there.

> To me, "rfkill" sounds intimidating and evokes thoughts of electronic  
> warfare, "microwave gun", "disrupting enemy's communications" and such  
> stuff :-)

Heh :-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
