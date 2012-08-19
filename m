Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:64143 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab2HSRvs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2012 13:51:48 -0400
Received: by wibhq12 with SMTP id hq12so2715610wib.1
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2012 10:51:47 -0700 (PDT)
MIME-Version: 1.0
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date: Sun, 19 Aug 2012 21:51:27 +0400
Message-ID: <CAHNKnsRVh_BXqW0CLfxO5WZCJ8UH7O=cHN-zh7AuM_pQj0xUqg@mail.gmail.com> (sfid-20120819_195152_069264_2EBE8832)
Subject: Per sta interfaces in WDS (4-address) mode
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello dear all,

please tell me, why in the WDS mode, the stack creates a new interface
for each WDS station, and this interface hostapd adds to the parent AP
interface bridge? Why we couldn't simply pass this frames via AP
interface?

-- 
With best wishes
Sergey Ryazanov
