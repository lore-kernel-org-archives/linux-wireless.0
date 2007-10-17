Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:22219 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997AbXJQOJL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2007 10:09:11 -0400
Received: by py-out-1112.google.com with SMTP id u77so4340156pyb
        for <linux-wireless@vger.kernel.org>; Wed, 17 Oct 2007 07:09:09 -0700 (PDT)
Message-ID: <43e72e890710170709j76f2430el57640cf46d07402c@mail.gmail.com> (sfid-20071017_150914_583533_B54DAAC2)
Date: Wed, 17 Oct 2007 10:09:08 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 3/3] consistently use ath5k in printks
Cc: "Bruno Randolf" <bruno@thinktube.com>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <1192619652.8841.13.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1192540838-26985-1-git-send-email-bruno@thinktube.com>
	 <1192540838-26985-2-git-send-email-bruno@thinktube.com>
	 <1192540838-26985-3-git-send-email-bruno@thinktube.com>
	 <1192540838-26985-4-git-send-email-bruno@thinktube.com>
	 <1192619652.8841.13.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/17/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2007-10-16 at 22:20 +0900, Bruno Randolf wrote:
>
> > the proc interface changed too from /proc/sys/dev/ath/ to /proc/sys/dev/ath5k/
>
> Ok, and why exactly is there a proc interface at all?

That shall be removed as well.

  Luis
