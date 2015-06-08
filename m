Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:32942 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbbFHJjX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 05:39:23 -0400
Received: by labpy14 with SMTP id py14so92710904lab.0
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jun 2015 02:39:22 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 8 Jun 2015 16:39:22 +0700
Message-ID: <CAAVw_ZFi3Q1hi+uoeO_V=XUMNhZCViVq5iPrrJL9UakKB46Mag@mail.gmail.com> (sfid-20150608_113927_353832_92076611)
Subject: mac80211 modification
From: Duy Tai Nguyen <duytai.cse@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I want to inject particular data into beacon frame in Android device.
I found two approaches:
1. Write loadable kernel module.
2. Modify MAC80211 subsystem
In the first approach, I found that I could not include directly
source code from MAC80211 sub system in folder /net/mac80211/. Thus, I
used the second approach, but, every time I change any line of source
code, it takes 30 minutes to build zImage  then install new kernel in
my Android device. Finally, I was stuck.
Therefore, my questions are:
1. Is it right approach to modify MAC80211 subsystem?
2. Are there any faster approach to modify MAC80211 and test source code?
3. I am curious about the way you write code and test MAC80211. Could
you explain in details?
Best Regards,
Duy Tai.
------------------------------------------------------------------------------------------------------------
Nguyen Duy Tai
Ym: kimjiwoo741
Phone: +841676919422
Faculty of Computer Science and Engineering.
University of Technology HCMC.
------------------------------------------------------------------------------------------------------------
