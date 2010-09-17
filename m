Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:48250 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751178Ab0IQCsW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 22:48:22 -0400
Received: from vs3017.wh2.ocn.ne.jp (125.206.180.250)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0363631700
	for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 11:48:21 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: wireless-testing or wireless-next
Date: Fri, 17 Sep 2010 11:48:39 +0900
Cc: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201009171148.39953.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John, Luis,

I'm a little confused about which tree to use. I though we should base driver 
development on wireless-testing, but I see that you merge patches into 
wireless-next first. So should we re-base patches to wireless-next before we 
send them?

Also, AFAIK, compat-wireless is based on linux-next, so if I want to create a 
compat-wireless package based on my latest driver changes (I need to do this 
frequently for testing my driver on my platform), I always run into problems 
because my latest driver is in wireless-testing and not in linux-next. Do you 
have any advise on a proper workflow here?

Thanks,
bruno
