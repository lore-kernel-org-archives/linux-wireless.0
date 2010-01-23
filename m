Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f194.google.com ([209.85.221.194]:62908 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab0AWAqN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 19:46:13 -0500
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 22 Jan 2010 16:45:47 -0800
Message-ID: <43e72e891001221645q4a4945cfk4c8b462641c20e18@mail.gmail.com>
Subject: compat-wireless-2.6.33-rc5 released for 802.11/bluetooth
To: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 2.6.33-rc5 kernel release was kicked out yesterday.  You can now
get the respective stable compat-wireless based [1] release on it [2]
which allows you to get the 2.6.33-rc5 802.11 and bluetooth subsystem
and driver updates installed on older kernels. This is like the
bleeding edge compat-wireless releases but are *stable* and should be
*stable*. Please report any issues ASAP. For details on changes you
can refer to the ChangeLog-2.6.33-rc5-wireless [3].

All reported compat_firmware_class issues should now be all gone.

 Luis

[1] http://wireless.kernel.org/en/users/Download/stable
[2] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.33/compat-wireless-2.6.33-rc5.tar.bz2
[3] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.33/ChangeLog-2.6.33-rc5-wireless
