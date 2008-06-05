Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:10143 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbYFERyo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 13:54:44 -0400
Received: by wa-out-1112.google.com with SMTP id j37so467592waf.23
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jun 2008 10:54:43 -0700 (PDT)
Message-ID: <1ba2fa240806051054t26ae5487s531962bf9ebcb2ff@mail.gmail.com> (sfid-20080605_195447_191478_369185C7)
Date: Thu, 5 Jun 2008 20:54:42 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: [PATCH 01/12] rfkill: clarify meaning of rfkill states
Cc: "Ivo van Doorn" <ivdoorn@gmail.com>,
	"Dan Williams" <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, "Dmitry Torokhov" <dtor@mail.ru>
In-Reply-To: <1212687773.13044.1256965165@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1212549017-30144-1-git-send-email-hmh@hmh.eng.br>
	 <1ba2fa240806041607j10841ac0qb11fe0d0b27953d8@mail.gmail.com>
	 <20080605003808.GA16599@khazad-dum.debian.net>
	 <200806051803.43193.IvDoorn@gmail.com>
	 <1ba2fa240806050936o383111cepcd6733d1ed205a26@mail.gmail.com>
	 <1212687773.13044.1256965165@webmail.messagingengine.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 5, 2008 at 8:42 PM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Thu, 5 Jun 2008 19:36:26 +0300, "Tomas Winkler" <tomasw@gmail.com> said:
>> Cannot this be just fixed with ~ sed -s/ON/OFF/g'  over the kernel?
>
> Absolutely NOT!
>
> You would have patches in flight, not to mention out-of-tree
> stuff, that you'd have no idea if they want the old or new meaning.
>
> Not to mention you'd never know what you forgot to convert, etc.
>
How many drivers today implement the rfkill interface? I guess no more then 10.

Tomas
