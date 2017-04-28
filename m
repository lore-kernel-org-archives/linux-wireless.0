Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8069 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2992674AbdD1KhH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2017 06:37:07 -0400
From: "Mohammed Shafi Shajakhan (Mohammed Shafi)"
        <mohammed@qti.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        Julia Lawall <julia.lawall@lip6.fr>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "mohammed@codeaurora.org" <mohammed@codeaurora.org>,
        "michal.kazior@tieto.com" <michal.kazior@tieto.com>,
        "kbuild-all@01.org" <kbuild-all@01.org>
Subject: Re: [PATCH] mac80211: Fix possible sband related NULL pointer
 de-reference (fwd)
Date: Fri, 28 Apr 2017 10:36:59 +0000
Message-ID: <1493375819334.47709@qti.qualcomm.com> (sfid-20170428_123714_439014_9FFD6E85)
References: <alpine.DEB.2.20.1704281205580.3387@hadrien>,<1493375202.2431.9.camel@sipsolutions.net>
In-Reply-To: <1493375202.2431.9.camel@sipsolutions.net>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-04-28 at 12:06 +0200, Julia Lawall wrote:=0A=
> Please check whether an unlock is missing on line 3009-3013.=0A=
=0A=
Yep, thanks. I'll fix it=0A=
=0A=
[shafi] thanks johannes and Julia ! sorry about the regression=
