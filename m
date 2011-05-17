Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62917 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab1EQL3f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 07:29:35 -0400
Received: by qwk3 with SMTP id 3so185563qwk.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 04:29:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305633602-4590-1-git-send-email-zajec5@gmail.com>
References: <1305633602-4590-1-git-send-email-zajec5@gmail.com>
Date: Tue, 17 May 2011 13:29:35 +0200
Message-ID: <BANLkTikDakeK3KUWqrm1sHpDAJPPL9mw4A@mail.gmail.com> (sfid-20110517_132939_135472_7BEA9D57)
Subject: Re: [PATCH 1/3] b43: add helpers for block R/W ops
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maybe I should have post cover letter with following info.

I've tested that patches with my BCM4311 (14e4:4312). Both dma and pio
still work :)

-- 
Rafał
