Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:56261 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759791AbYBOV4c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 16:56:32 -0500
Received: by py-out-1112.google.com with SMTP id u52so1037449pyb.10
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2008 13:56:31 -0800 (PST)
Message-ID: <43e72e890802151356x52ce6ac5l8adf21374d9cf832@mail.gmail.com> (sfid-20080215_215700_940603_8D59F29E)
Date: Fri, 15 Feb 2008 16:56:30 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: matthias@kaehlcke.net, mcgrof@gmail.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [patch 3/3] Convert wpa_sem in a mutex
In-Reply-To: <20080215195707.GD22741@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080215195329.912560854@kaehlcke.net>
	 <20080215195707.GD22741@traven>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 15, 2008 at 2:57 PM,  <matthias@kaehlcke.net> wrote:
> The semaphore wpa_sem is used as mutex, convert it to the mutex API
>
>  Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

Acked-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>

  Luis
