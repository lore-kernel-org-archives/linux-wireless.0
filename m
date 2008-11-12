Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.187]:29340 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbYKLAc5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 19:32:57 -0500
Received: by rn-out-0910.google.com with SMTP id k40so170568rnd.17
        for <linux-wireless@vger.kernel.org>; Tue, 11 Nov 2008 16:32:56 -0800 (PST)
Message-ID: <43e72e890811111632x2c641d2cmeb69c0a0ea95382e@mail.gmail.com> (sfid-20081112_013312_566629_32DDF280)
Date: Tue, 11 Nov 2008 16:32:56 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "David Woodhouse" <dwmw2@infradead.org>,
	"Dan Williams" <dcbw@redhat.com>
Subject: libertas_tf should replace libertas_usb on compat-wireless?
Cc: linux-wireless <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By default do we want users of compat-wireless to get libertas_usb or
libertas_tf? Both drivers are for Marvell Libertas 8388 USB 802.11b/g
cards so we need to pick one.

  Luis
