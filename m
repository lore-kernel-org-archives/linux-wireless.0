Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:35789 "EHLO
	mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161067AbcBQLJJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 06:09:09 -0500
Received: by mail-lf0-f49.google.com with SMTP id l143so8354768lfe.2
        for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2016 03:09:08 -0800 (PST)
Received: from libertarian.asterius.net ([178.70.83.225])
        by smtp.gmail.com with ESMTPSA id ke9sm130050lbc.28.2016.02.17.03.09.07
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Feb 2016 03:09:07 -0800 (PST)
Date: Wed, 17 Feb 2016 06:09:09 -0500
From: German <gentgerman@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Wrong wireless nick card name loaded on reboot
Message-ID: <20160217060909.694a9aff@libertarian.asterius.net> (sfid-20160217_120914_637896_3EA8201B)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi list, 

A couple of days ago I asked why my pc changes the wireless card name.
It switches between AR9285 ( right) and AR5008 ( wrong). Someone
suggested  that this is because another kernel module is loaded by
mistake. Well, it is not the case. When system identified with AR9285,
it loads ath9k and I can connect to the router. When system identifies
my card as AR5008, no kernel module is present at all ( lspci -k). The
wrong card name occurs only when system rebooted. If I gracefully shut
down the system, it always comes up with a right name for the card
( AR9285). So, how to force the system identify my card right no matter
if I reboot or shut down? Thank you.
