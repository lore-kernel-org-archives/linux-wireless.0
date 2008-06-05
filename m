Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52860 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751802AbYFERmy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 13:42:54 -0400
Message-Id: <1212687773.13044.1256965165@webmail.messagingengine.com> (sfid-20080605_194301_551658_D884CE6E)
From: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
To: "Tomas Winkler" <tomasw@gmail.com>,
	"Ivo van Doorn" <ivdoorn@gmail.com>
Cc: "Dan Williams" <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, "Dmitry Torokhov" <dtor@mail.ru>
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
References: <1212549017-30144-1-git-send-email-hmh@hmh.eng.br>
   <1ba2fa240806041607j10841ac0qb11fe0d0b27953d8@mail.gmail.com>
   <20080605003808.GA16599@khazad-dum.debian.net>
   <200806051803.43193.IvDoorn@gmail.com>
   <1ba2fa240806050936o383111cepcd6733d1ed205a26@mail.gmail.com>
Subject: Re: [PATCH 01/12] rfkill: clarify meaning of rfkill states
In-Reply-To: <1ba2fa240806050936o383111cepcd6733d1ed205a26@mail.gmail.com>
Date: Thu, 05 Jun 2008 14:42:53 -0300
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 5 Jun 2008 19:36:26 +0300, "Tomas Winkler" <tomasw@gmail.com> said:
> Cannot this be just fixed with ~ sed -s/ON/OFF/g'  over the kernel?

Absolutely NOT!

You would have patches in flight, not to mention out-of-tree
stuff, that you'd have no idea if they want the old or new meaning.

Not to mention you'd never know what you forgot to convert, etc.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

