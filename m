Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:53770 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbYBOVzS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 16:55:18 -0500
Received: by py-out-1112.google.com with SMTP id u52so1037107pyb.10
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2008 13:55:17 -0800 (PST)
Message-ID: <43e72e890802151355x3bab40beib98feb887e0baacb@mail.gmail.com> (sfid-20080215_215524_797047_FD62A6E8)
Date: Fri, 15 Feb 2008 16:55:16 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: matthias@kaehlcke.net, mcgrof@gmail.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
Subject: Re: [patch 2/3] Convert stats_sem in a mutex
In-Reply-To: <20080215195659.GC22741@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080215195329.912560854@kaehlcke.net>
	 <20080215195659.GC22741@traven>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 15, 2008 at 2:56 PM,  <matthias@kaehlcke.net> wrote:
> The semaphore stats_sem is used as mutex, convert it to the mutex API
>
>  Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

Acked-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>

Thanks, BTW, for the next set you send please review the linux
wireless submitting patch guide. You just need to address the patch to
John, the maintainers and CC linux-wireless.

http://linuxwireless.org/en/developers/Documentation/SubmittingPatches

  Luis
