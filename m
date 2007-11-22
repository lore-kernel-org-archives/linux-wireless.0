Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.187]:37701 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751955AbXKVUj5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 15:39:57 -0500
Received: by rn-out-0102.google.com with SMTP id s46so4147245rnb
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2007 12:39:56 -0800 (PST)
Message-ID: <6995ca080711221239t2947765ds765fd933fce5de31@mail.gmail.com> (sfid-20071122_204006_138946_7726FA26)
Date: Thu, 22 Nov 2007 15:39:55 -0500
From: "Vadim Peretokin" <vperetokin@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Belin FD7010 v7
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I own a Belkin FD7010 version 7000 wireless card, and am unsure about
it's state with linux compatibility. It's based on the Realtek 8185
chipset, which I thought was linux-friendly, but alas, it apparently
wasn't - my Ubuntu 7.10 didn't recognize it at all. I looked at the
entry for it in the website:

"RTL8185 based cards. There is an official Realtek driver, which
offers limited functionality and is known to cause serious problems
(including random system crashes). There also is the rtl8180
opensource driver which is supposed to also work with 8185 (and for
some people it does), but there is no solution that works with
majority of (numerous) RTL8185-based cards. Some cards are not
supported by any of them. For more info about driver problems try
searching any major Linux forums."

But that is very ambiguous. Does that mean if anything is being done
to make this card work, do you know?
