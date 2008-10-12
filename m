Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:55060 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261AbYJLBoW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2008 21:44:22 -0400
Date: Sat, 11 Oct 2008 22:44:15 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH 3/5] rfkill: add master_switch_mode and EPO lock to
	rfkill and rfkill-input
Message-ID: <20081012014415.GA15867@khazad-dum.debian.net> (sfid-20081012_034429_889761_603D1CDE)
References: <1223586933-17753-1-git-send-email-hmh@hmh.eng.br> <20081009212049.GA16430@khazad-dum.debian.net> <20081010004933.GA23514@khazad-dum.debian.net> <200810111553.49466.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200810111553.49466.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 11 Oct 2008, Ivo van Doorn wrote:
> Although I think RFKILL_NEED_SWSET could be removed entirely if it isn't
> used anyway, we might do that later.

As I said, that code is NOT obvious.  It is NOT too difficult to come up
with either, but I think it is safer if it is kept around for a while, or
just kept enabled but unused if you dislike the #ifdefs so much...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
