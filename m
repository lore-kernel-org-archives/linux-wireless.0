Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [62.4.27.34] ([62.4.27.34]:35909 "EHLO mail.openmailbox.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbaJ0DFP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Oct 2014 23:05:15 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.openmailbox.org (Postfix) with ESMTP id 8A1892E0514
	for <linux-wireless@vger.kernel.org>; Mon, 27 Oct 2014 03:57:32 +0100 (CET)
Received: from mail.openmailbox.org ([62.4.27.34])
	by localhost (mail.openmailbox.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kO6fu5v0Uwut for <linux-wireless@vger.kernel.org>;
	Mon, 27 Oct 2014 03:57:30 +0100 (CET)
Message-ID: <544DB5A8.7090405@openmailbox.org> (sfid-20141027_040636_325420_A7F9A918)
Date: Mon, 27 Oct 2014 11:02:00 +0800
From: Etna <etna@openmailbox.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: MediaTek WiFi hardware support in upstream kernel
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am not a developer, but I stumbled upon this just a couple of days ago 
in the OpenWRT forums:

https://forum.openwrt.org/viewtopic.php?id=53215

In short, MediaTek is looking for volunteers to help get their drivers 
mainlined in the upstream kernels; this includes drivers for their USB 
and PCI wifi hardware under both the MediaTek and Ralink brands. They 
are willing to provide "chip info, reference driver, dev board, etc" and 
even some degree of sponsorship, apparently subject to their 
management's approval.

In exchange, they require that the volunteers fulfill the following 
requirements:
- skilled in wifi driver development
- provide a suitable schedule / roadmap
- be able to get the code mainlined in the official linux kernel.

Those who are keen on taking up the task can contact the original poster 
at hua.shao[AT]mediatek.com

**Disclaimer: I am in no way related to, or under the employ of MediaTek 
or Ralink. I am only posting this here because I have a handful of MT 
wifi chips which I hope to see being supported in the upstream kernel so 
that I can actually use them under Linux,
