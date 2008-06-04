Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:6390 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbYFDDcE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 23:32:04 -0400
Message-ID: <20080603233202.2ysgs5s9n4cww4s4-cebfxv@webmail.spamcop.net> (sfid-20080604_053208_444852_2383342E)
Date: Tue, 03 Jun 2008 23:32:02 -0400
From: Pavel Roskin <proski@gnu.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH 01/12] rfkill: clarify meaning of rfkill states
References: <1212549017-30144-1-git-send-email-hmh@hmh.eng.br>
	<1212549017-30144-2-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1212549017-30144-2-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Henrique de Moraes Holschuh <hmh@hmh.eng.br>:

> rfkill really should have been named rfswitch.

I hope it's not too late to rename.  If it's planned in advance and  
the related userspace utilities are given an advance notice, it should  
go smoothly.  Linux went through bigger changes.

To me, "rfkill" sounds intimidating and evokes thoughts of electronic  
warfare, "microwave gun", "disrupting enemy's communications" and such  
stuff :-)

-- 
Regards,
Pavel Roskin
