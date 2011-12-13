Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59143 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab1LMIey (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 03:34:54 -0500
Received: by pbbb2 with SMTP id b2so117416pbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Dec 2011 00:34:54 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 13 Dec 2011 14:04:54 +0530
Message-ID: <CAFeFRo=rcrOnh1J84=XMWSyj8EzjMGYXetH1YkEiWBHBxz=3jQ@mail.gmail.com> (sfid-20111213_093511_419140_2B06202B)
Subject: Concurrent Mode Mutiple VIF question
From: Ajit Pal Singh <ajitpallearn@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Community,

I am trying to implement Multiple Virtual Interface support for a
hardware which can support mulitple channels per hardware
concurrently.( For ex : AP and STA concurrently on different channels)
.
However I cannot find support for channels being configured per VIF.
Could you please help me in understanding if I can support different
channels per VIF in the current mac80211 implementation.

Regards
Ajitpal Singh
