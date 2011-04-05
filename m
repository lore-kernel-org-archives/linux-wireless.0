Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42394 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab1DEOGH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 10:06:07 -0400
Received: by fxm17 with SMTP id 17so283030fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2011 07:06:05 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: Re: [RFC] mac80211: Add station uptime in debugfs
Date: Tue, 5 Apr 2011 16:04:16 +0200
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
References: <1302010795-2522-1-git-send-email-mshajakhan@atheros.com>
In-Reply-To: <1302010795-2522-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201104051604.16143.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 5. April 2011 schrieb Mohammed Shafi Shajakhan:
> From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
> 
> Add station uptime parameter in debugfs. This will be helpful to get a
> measure of stability of connection and also during stress testing.

It might even make sense to make this available through nl80211. At least
in AP mode it would be interesting to see how long each STA is already
connected.

Helmut
