Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:60548 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaJVNr4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 09:47:56 -0400
Received: by mail-lb0-f178.google.com with SMTP id w7so2888848lbi.9
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2014 06:47:55 -0700 (PDT)
From: Karsten Wiese <fzuuzf@googlemail.com>
To: Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] Fix rtl8192cu in 3.18-rc1
Date: Wed, 22 Oct 2014 15:47:31 +0200
Message-Id: <1413985654-25070-1-git-send-email-fzuuzf@googlemail.com> (sfid-20141022_154759_848646_9D394E8E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In 3.18-rc1 the rtl8192cu driver does not register a wlan%d device.
Attached patches fix that and the oopses I encountered.
Here the driver works again driving a device as station to a 802.11g 
access point.

Regards,
Karsten
 

