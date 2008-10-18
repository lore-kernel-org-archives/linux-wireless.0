Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:50347 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbYJRBK0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Oct 2008 21:10:26 -0400
Received: by yw-out-2324.google.com with SMTP id 9so167744ywe.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Oct 2008 18:10:25 -0700 (PDT)
Message-ID: <43e72e890810171810t1c65642g998db601cfe2a390@mail.gmail.com> (sfid-20081018_031038_006199_0EA0868E)
Date: Fri, 17 Oct 2008 18:10:25 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Power saving on mac80211
Cc: "Zhu Yi" <yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So I wanted to review power saving requirements for mac80211 and see
who else out there is focusing on this now or *really soon* so we can
divide and conquer on this. If you are interested please let us know
so we can coordinate.

First please see:

http://wireless.kernel.org/en/developers/todo-list#powersaving

  * Suspend/resume seems pretty straight forward so far, thanks to
Johannes' efforts
  * What do we have to do, if anything at all, for PCI Express (PCIe)
Active State Power Management (ASPM)?
  * There seems to be u-APSD patches for Intel for AP support but I
couldn't find them posted anywhere, can someone provide a link to
them?

Is this a complete list, anything else?

  Luis
