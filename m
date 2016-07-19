Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35153 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbcGSQHB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 12:07:01 -0400
Received: by mail-wm0-f67.google.com with SMTP id i5so3299166wmg.2
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2016 09:07:00 -0700 (PDT)
From: Christopher Williamson <home@chrisaw.com>
MIME-Version: 1.0
Date: Tue, 19 Jul 2016 12:06:58 -0400
Message-ID: <CANXHH3n7Gp+0NA8j9ji0S2dsYqbR9SE0MEuB5oKENE6Asz9j=w@mail.gmail.com> (sfid-20160719_180705_575089_BDA42A63)
Subject: Problem connecting to wifi on libertas_cpio (sd8686)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everyone!

I’ve just got myself a Viliv N5 and am trying to get the integrated
Wifi chipset working on it.

I am able to see networks around me but any attempts to connect them
appear to time out and fail.

I have filed a linux kernel bug related to this issue:
https://bugzilla.kernel.org/show_bug.cgi?id=135421

I figured here may be a good place to ask about it and hopefully to
get to the bottom of why it happens and how I can help to fix it.

Happy to provide any information which may be helpful! :)

Christopher Williamson

Note: Apologies for anyone also on the libertas-dev mailing list - I
did also post this there but so far haven’t had any response so I
figured it wouldn’t hurt posting it here too in the hopes someone has
seen this issue before.
