Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:39954 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaBJQvW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 11:51:22 -0500
Received: by mail-ie0-f175.google.com with SMTP id ar20so3655180iec.20
        for <linux-wireless@vger.kernel.org>; Mon, 10 Feb 2014 08:51:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAVw_ZE8jO2PU_qsEnWQ_6VtqLUG7G=j2i9BUvQvWeO4YXiK3A@mail.gmail.com>
References: <CAAVw_ZERCJhy4-Qczn36_CywE6_ceRc03BHfpvavn=A=xo=qRA@mail.gmail.com>
	<52CC4799.4080806@candelatech.com>
	<CABPxzYLUmq1sUKDX=sN6YbTfvXem53soy+b7kL4DSytW2+J9fg@mail.gmail.com>
	<CAAVw_ZE8jO2PU_qsEnWQ_6VtqLUG7G=j2i9BUvQvWeO4YXiK3A@mail.gmail.com>
Date: Mon, 10 Feb 2014 23:51:22 +0700
Message-ID: <CAAVw_ZHtjJsY3_JZwXDA_CJF7D5poejiCgzPi0YaBnmy7y7WLw@mail.gmail.com> (sfid-20140210_175127_242665_4423F935)
Subject: Re: Virtual Network Interface
From: Duy Tai Nguyen <duytai.cse@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Ben Greear <greearb@candelatech.com>,
	Krishna Chaitanya <chaitanya.mgit@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear sir!
In my project, I need a mesh network between a group of android
devices. But one complex issue is that :
" I need to create at least 2 interfaces based on only one physical device ".
When @BenGreear said that not all of android devices supported that
function. I have searched for other solution with WiFi Direct, but I
have met the same problem.  Now, I need some answers to explore my
problems:
1. What is the different between supported virtual interface NIC and
NIC, which don't support virtual interface?(about channel, firmware or
something like that) ?
2. When android device connected to an AP, It also see a list of other
APs at the same time. That mean android device can interact
concurrently with many APs. Therefore, I think we can find the way
that one android device can talk with many android devices at the same
time. Is that true ?
3. Can I modify the content of Mac802.11 frame by only modifying the
kernel code?
Because I am a newbie and Information about wireless kernel is scarce.
I hope I can receive your answer! thanks you!
Best regard !
-----------------------------------------------------------------------------------------------------------------
Nguyen Duy Tai
Ym: kimjiwoo741
Phone: +841676919422
Faculty of Computer Science and Engineering.
University of Technology HCMC.
-----------------------------------------------------------------------------------------------------------------
