Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:35019 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab3GIIrk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 04:47:40 -0400
Received: by mail-la0-f43.google.com with SMTP id gw10so4592732lab.16
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jul 2013 01:47:37 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 9 Jul 2013 10:47:37 +0200
Message-ID: <CAAU0D9dyrsHKw6cvbfNnhodQOC9_Bhxm0xiDqmKXTuN8Lby3DQ@mail.gmail.com> (sfid-20130709_104743_814569_5F097024)
Subject: intel 4965 fails to set channel 12 or 13
From: Hendrik-Jan Heins <hjheins@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear list,

On Debian Wheezy, kernel 3.2, I am trying to get my iwl4965 to
scan/find/connect on channels 13 and 13. As I am in Europe, this
should be no issue.
However: I can not get these channels activated on my card at all!
I tried the following:
- Using the regdom option, setting to EU, DE, or PL (I see the correct
setting in /sys/modules/cfg80211/parameters/ieee_regdom...
- Completely disabling CRDA, and manually loading regdom through iw
reg set EU/DE/PL/US

In all cases, I see some changes in the channels listed, but I never
get 12 and 13 enabled.

Does anyone has an idea on this?

thanks,

Hendrik-Jan
