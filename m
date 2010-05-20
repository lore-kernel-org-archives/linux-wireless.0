Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:41955 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214Ab0ETTkh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 May 2010 15:40:37 -0400
Received: by wwi18 with SMTP id 18so149606wwi.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 May 2010 12:40:36 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 20 May 2010 15:40:36 -0400
Message-ID: <AANLkTinMa92irnw8fH8PPO6egbAVDFWBg4pCPp3dInwd@mail.gmail.com>
Subject: How the mac80211 handle "\0" essid?
From: leo liang <leoliang9@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Does any one know that if the application send "\0" as essid to
mac80211, how it handle this case?

I am studying mac80211 code, but I don't get this answer yet. Could
some give me the answer or a tip?

Thanks.
