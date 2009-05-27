Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:21021 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391AbZE0XaQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 19:30:16 -0400
Received: by yx-out-2324.google.com with SMTP id 3so2814823yxj.1
        for <linux-wireless@vger.kernel.org>; Wed, 27 May 2009 16:30:17 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 27 May 2009 16:30:17 -0700
Message-ID: <45e8e6c40905271630x39bcfca6w72560150222e7960@mail.gmail.com>
Subject: ath9k locks up when bringing up a mesh point interface
From: Andrey Yurovsky <andrey@cozybit.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With today's wireless-testing, bring up an ath9k mesh point locks up
my test laptop (single CPU) but I don't get any messages (/proc/sysrq
set to 9, unfortunately I can't use a serial console right now).

  -Andrey
