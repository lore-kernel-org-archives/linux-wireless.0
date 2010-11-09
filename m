Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:32944 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab0KIBmY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Nov 2010 20:42:24 -0500
Received: by wwi18 with SMTP id 18so222340wwi.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Nov 2010 17:42:23 -0800 (PST)
Message-ID: <4CD8A71E.6040604@lwfinger.net>
Date: Mon, 08 Nov 2010 19:42:54 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
Subject: What kind of Atheros device is this?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On the openSUSE forum, one of the posters got this output from lspci -nnk:

02:00.0 Network controller [0280]: Atheros Communications Inc. Device
[168c:002c] (rev 01)
	Subsystem: Device [1a3b:1112]

I did not find these PCI IDs for any device in wireless or staging. What is it,
and what driver should it use?

Thanks,

Larry
