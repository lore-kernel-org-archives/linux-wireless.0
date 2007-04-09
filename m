Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.234]:1474 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbXDIAXe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2007 20:23:34 -0400
Received: by nz-out-0506.google.com with SMTP id s1so925006nze
        for <linux-wireless@vger.kernel.org>; Sun, 08 Apr 2007 17:23:33 -0700 (PDT)
Message-ID: <a44ae5cd0704081723q5b66baa8u23d2dda6d7ac0c91@mail.gmail.com>
Date: Sun, 8 Apr 2007 20:23:32 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: wireless <linux-wireless@vger.kernel.org>
Subject: Is it possible to test ipw2200 / mac80211 in 2.6.21-rc6-mm1?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I notice that mac80211 is in Andrew's tree, but I don't seem to be
able to build ipw2200 without including the current softmac stuff.
I'd like to test the mac80211 code.  Is there a way to do this for
ipw2200 currently?  Do I have to use one of the development git trees?

Thanks,
       Miles
