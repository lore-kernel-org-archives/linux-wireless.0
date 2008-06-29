Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:44043 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755318AbYF2Sdx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jun 2008 14:33:53 -0400
Date: Sun, 29 Jun 2008 15:33:48 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: drago01 <drago01@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>, stefano.brivio@polimi.it,
	Larry Finger <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH] b43/b43legacy: add RFKILL_STATE_HARD_BLOCKED support
Message-ID: <20080629183348.GC583@khazad-dum.debian.net> (sfid-20080629_203359_041452_E3DA7D40)
References: <f6ca9fed0806291020j151c64fbx7705fe568b42adff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f6ca9fed0806291020j151c64fbx7705fe568b42adff@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 29 Jun 2008, drago01 wrote:
> The attached  patch adds RFKILL_STATE_HARD_BLOCKED to the b43/b43legacy drivers.

While at it, if b43 still has any input layer stuff, especially any input
polldev stuff, please rip that off.

Userspace or a platform driver should listen to the b43 reports on the
rfkill notifier chain (or uevents) and issue the input events.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
