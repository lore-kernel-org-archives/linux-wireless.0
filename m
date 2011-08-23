Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33836 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab1HWMpx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 08:45:53 -0400
Received: by ywf7 with SMTP id 7so44926ywf.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 05:45:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1313250844-4526-1-git-send-email-zajec5@gmail.com>
References: <1313250844-4526-1-git-send-email-zajec5@gmail.com>
Date: Tue, 23 Aug 2011 14:45:51 +0200
Message-ID: <CACna6rwoyPuwnzcw4BR5dmOiX9ogsTbquaG6qwRMZtLZytNnoA@mail.gmail.com> (sfid-20110823_144556_464441_A2E8B408)
Subject: Re: [PATCH] b43: HT-PHY: init: add missing small-tables writes
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 13 sierpnia 2011 17:54 użytkownik Rafał Miłecki
<zajec5@gmail.com> napisał:
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> John: this one depends on
> [RFC][PATCH] b43: HT-PHY: allow writing longer tables with a single call
> , please apply the one above.

John, I've asked you to apply the mentioned patch before this one. By
applying *just* this one you've broken build for ppl trying *BROKEN*
HT support.

-- 
Rafał
