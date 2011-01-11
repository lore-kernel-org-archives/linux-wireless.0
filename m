Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57200 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab1AKVUg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 16:20:36 -0500
Received: by ywl5 with SMTP id 5so8093637ywl.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jan 2011 13:20:35 -0800 (PST)
Subject: Mesh join/leave
From: Steve Brown <sbrown@cortland.com>
Reply-To: sbrown@cortland.com
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Jan 2011 16:20:28 -0500
Message-ID: <1294780828.2383.0.camel@mythtv.ewol.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In testing this, the command "iw mesh0 mesh leave" doesn't stop
beaconing. Beaconing continues with a null mesh id.

Is this the intended behavior?

Steve

iw version 0.9.21-35-gba292ae
wireless-testing at commit 315f05c479f8e98e2df0e23a1bc0829b7e374fe9



