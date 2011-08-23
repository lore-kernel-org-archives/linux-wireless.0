Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42880 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab1HWNow convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 09:44:52 -0400
Received: by ywf7 with SMTP id 7so87402ywf.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 06:44:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1313100627-26186-1-git-send-email-zajec5@gmail.com>
References: <1313100627-26186-1-git-send-email-zajec5@gmail.com>
Date: Tue, 23 Aug 2011 15:44:51 +0200
Message-ID: <CACna6rwbzX241MVCwPd1qRbU1uWRcwjyVguBhcLs8xPcDzV0GQ@mail.gmail.com> (sfid-20110823_154455_530718_6B2E2F03)
Subject: Re: [RFC][PATCH] b43: HT-PHY: allow writing longer tables with a
 single call
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 12 sierpnia 2011 00:10 użytkownik Rafał Miłecki
<zajec5@gmail.com> napisał:
> Sometime we need to write table which is 2-10 elements long. It's easier
> to create such a function instead of defining array every time.

John, take this one please.

-- 
Rafał
