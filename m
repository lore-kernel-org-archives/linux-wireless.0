Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:34336 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250AbZLNRpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 12:45:12 -0500
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 14 Dec 2009 09:44:50 -0800
Message-ID: <43e72e890912140944j1d07caeaq10bddb1d4be9dd7d@mail.gmail.com>
Subject: Compat-wireless for 2.6.32
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2.6.32 went out last week, based on this release we now have a
compat-wireless release [1]. You can find the wireless specific
ChangeLog at orbit [2]. This package enables usage of the 2.6.32
wireless subsystem on older kernels. For more information please refer
to its upstream wiki [3]. If you find any issues with wireless on this
package please report them [4] ASAP.

  Luis

[1] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.32/compat-wireless-2.6.32.tar.bz2
[2] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.32/ChangeLog-2.6.32-wireless
[3] http://wireless.kernel.org/en/users/Download/stable
[4] http://wireless.kernel.org/en/users/Documentation/Reporting_bugs
