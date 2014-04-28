Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:46487 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaD1PoD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Apr 2014 11:44:03 -0400
Received: by mail-ob0-f171.google.com with SMTP id uy5so7513839obc.2
        for <linux-wireless@vger.kernel.org>; Mon, 28 Apr 2014 08:44:02 -0700 (PDT)
Message-ID: <535E7741.1030607@lwfinger.net> (sfid-20140428_174409_026827_BF52D1D9)
Date: Mon, 28 Apr 2014 10:44:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Tim Gardner <rtg.canonical@gmail.com>
CC: Nicolas Vaquero <nicovaq92@hotmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Kernel source
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tim,

I'm sorry to bother you, but I have been contacted on the linux-wireless ML by 
Nicolas Vaqueroa, who is a 12.04 LTS user. His problem is that he gets a fatal 
kernel oops when he enables wifi using driver rtl8192ce. The system is OK 
through kernel 3.8.0-36, bu he has the problem for -37 and later. I reviewed the 
changelog for -36 => -37 without seeing any modifications that could cause problems.

Is there a link to the 3.8.0-37 source? I could not find it on the Ubuntu web 
pile. With it, I should be able to fix his problem as long as I can duplicate it.

Thanks,

Larry
