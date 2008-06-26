Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:29352 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbYFZXD6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 19:03:58 -0400
Received: by wa-out-1112.google.com with SMTP id j37so147589waf.23
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jun 2008 16:03:56 -0700 (PDT)
Message-ID: <1ba2fa240806261603g30c3e757y9166c2f9e05f7666@mail.gmail.com> (sfid-20080627_010402_149025_79CCD304)
Date: Fri, 27 Jun 2008 02:03:56 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"David Miller" <davem@davemloft.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: compat-wireless high packet loss.
Cc: "Linux Wireless" <linux-wireless@vger.kernel.org>,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
	"Cohen, Guy" <guy.cohen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We've experienced very high packet loss when using latest
compat-wireless witth iwlwifi driver over 2.6.24 and 2.6.25 stable
kernels. This is not happening with 2.6.26-rc3 as a target kernel (not
sure about rc1 and rc2)
The traffic is UDP TX with large tx buffers ~26000.
We are still investigating yet if someone has any idea please share with us.
Thanks
Tomas
