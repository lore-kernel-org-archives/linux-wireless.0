Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39253 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab1GNUqV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 16:46:21 -0400
Received: by pvg12 with SMTP id 12so522361pvg.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jul 2011 13:46:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1310672961-5311-3-git-send-email-zajec5@gmail.com>
References: <1310672961-5311-1-git-send-email-zajec5@gmail.com>
	<1310672961-5311-3-git-send-email-zajec5@gmail.com>
Date: Thu, 14 Jul 2011 22:46:20 +0200
Message-ID: <CACna6rwq9MRnXAO_6acZd6MV1X7k4woY7DvtRY7DO=gMXEchHA@mail.gmail.com> (sfid-20110714_224624_294548_46F81288)
Subject: Re: [PATCH 3/4] bcma: implement BCM4331 workaround for external PA lines
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 14 lipca 2011 21:49 użytkownik Rafał Miłecki <zajec5@gmail.com> napisał:
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

John, drop this one patch for now, please.

It contains typo and breaks SPROM reading on BCM4331. We have to
understand BCM4331 workaround better. This probably has to be applied
on some specific stage, but we don't know it yet.

-- 
Rafał
