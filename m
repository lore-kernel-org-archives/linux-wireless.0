Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:38525 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab3DTGvC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Apr 2013 02:51:02 -0400
Received: by mail-ob0-f175.google.com with SMTP id wp18so875099obc.34
        for <linux-wireless@vger.kernel.org>; Fri, 19 Apr 2013 23:51:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365703360-19982-1-git-send-email-shenhan@google.com>
References: <1365703360-19982-1-git-send-email-shenhan@google.com>
Date: Sat, 20 Apr 2013 08:51:01 +0200
Message-ID: <CACna6rwUONMQqrT1C5K0qq5qp03fz+ghKpL1x+Rz_9S31TzhNw@mail.gmail.com> (sfid-20130420_085115_022326_68B529CF)
Subject: Re: [PATCH] Fix uninitialized-variable warnings.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Han Shen <shenhan@google.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	chaoming_li@realsil.com.cn
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/4/11 Han Shen <shenhan@google.com>:
> GCC 4.8 is spitting out uninitialized-varaible warnings against "drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c".
> This trivial patch just adds initialization to the variable.

Could you use prefixes for your patches? Like
rtl8192c: foo

-- 
Rafał
