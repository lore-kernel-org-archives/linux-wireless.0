Return-Path: <linux-wireless-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:39410 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752647AbcKJV4N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Nov 2016 16:56:13 -0500
Message-Id: <1478814972.2686901.784042113.31AFDC88@webmail.messagingengine.com>
From: Daniel Aleksandersen <code@daniel.priv.no>
To: Linux kernel wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Subject: =?UTF-8?Q?=E2=80=9CWireless=20usage=20of=20pm-qos=E2=80=9D?=
Date: Thu, 10 Nov 2016 22:56:12 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patch from Johannes Berg removed the /dev/network_latency system,
right?
http://marc.info/?l=3Dlinux-wireless&m=3D144483867919159&w=3D2

So shouldn=E2=80=99t all the documentation be updated to indicate that it h=
as
been removed?

https://wireless.wiki.kernel.org/en/developers/documentation/pm-qos
https://wireless.wiki.kernel.org/en/developers/documentation/ieee80211/powe=
r-savings
https://www.kernel.org/doc/Documentation/power/pm_qos_interface.txt
--=20
Daniel Aleksandersen
