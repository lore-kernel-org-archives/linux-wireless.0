Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f194.google.com ([209.85.221.194]:53002 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425Ab0AVXbi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 18:31:38 -0500
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 22 Jan 2010 15:31:10 -0800
Message-ID: <43e72e891001221531m7f14a09bsb78e82b16e844f64@mail.gmail.com>
Subject: Dynamic power-save and pm-qos support on 802.11
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, mark gross <mgross@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo had long ago implemented dynamic power save, and then
Johannes Berg added pm-qos support to tune power save and dynamic
power save based on this. In hopes to help userspace help tune dynamic
power save or use pm-qos to further save power I've added some initial
docs for both. Please help revise, and extend it:

http://wireless.kernel.org/en/users/Documentation/dynamic-power-save
http://wireless.kernel.org/en/developers/Documentation/pm-qos

Its a wiki, so if you see something wrong please just update it.

  Luis
