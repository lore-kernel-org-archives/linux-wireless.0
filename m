Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:36472 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751933Ab0EISVQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 May 2010 14:21:16 -0400
Received: from [192.168.1.10] (builder.redfish-solutions.com [192.168.1.10])
	(authenticated bits=0)
	by mail.redfish-solutions.com (8.14.4/8.14.4) with ESMTP id o49IBvJl029160
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sun, 9 May 2010 12:11:58 -0600
Message-ID: <4BE6FAED.4030407@redfish-solutions.com>
Date: Sun, 09 May 2010 12:11:57 -0600
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
Subject: Jumbo frame messages?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm running linux 2.6.27.42 with compat-wireless 2010-04-26 and using an
AR-5413 card (ath5k).

I'm also running hostapd 0.7.1 with WPA2 authentication.

I'm seeing a lot of:

May  9 12:07:21 pbx user.warn kernel: ath5k phy0: unsupported jumbo

I thought this issue was resolved a while ago.

Anyone have a root cause on this, or a workaround?

Thanks,

-Philip

