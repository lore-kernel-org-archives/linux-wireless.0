Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:38499 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab3AWK7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2013 05:59:52 -0500
Received: by mail-wi0-f182.google.com with SMTP id hn14so578365wib.3
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jan 2013 02:59:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1358884243-29668-1-git-send-email-zajec5@gmail.com>
References: <1358884243-29668-1-git-send-email-zajec5@gmail.com>
Date: Wed, 23 Jan 2013 11:59:50 +0100
Message-ID: <CACna6rxsqDQNr=mNf+FyGOoc+iWHwomPazdwm=whdUVG2g4r=A@mail.gmail.com> (sfid-20130123_115956_650533_494A2E60)
Subject: Re: [PATCH V2] bcma: register platform device for parallel flash
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/1/22 Rafał Miłecki <zajec5@gmail.com>:
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> V2: fix error message (s/serial/parallel/)

Please drop this patch, I'll try to use physmap-flash.

-- 
Rafał
