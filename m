Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.178]:2520 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbYDGEhB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2008 00:37:01 -0400
Received: by el-out-1112.google.com with SMTP id v27so826123ele.17
        for <linux-wireless@vger.kernel.org>; Sun, 06 Apr 2008 21:36:58 -0700 (PDT)
Reply-To: <cs010101@gmail.com>
From: =?ks_c_5601-1987?B?sei/tciv?= <cs010101@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: Q) ath5k : when using iwconfig?
Date: Mon, 7 Apr 2008 13:36:51 +0900
Message-ID: <001201c89869$01aafbf0$3b0aa8c0@39fb6b6b6f434b3> (sfid-20080407_053719_222946_18EA75FA)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ks_c_5601-1987"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello~ be nice day~

when 'iwconfig ath0 options,

if config 'iwconfig ath0 option1' and 'iwconfig ath0 option2' and 'iwconfig
ath0 option3' and ....., no problem.

but if config ' iwconfig ath0 option1 option2 option3 option4', system down.

no dmesg message.

driver version is Nov, 2007. atheros chipset is 5414chipset. Options are
'essid  kkk', 'mode ad-hoc', 'channel 161', 'rate ...'.

