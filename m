Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43423 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625Ab2BGVzc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 16:55:32 -0500
Received: by iacb35 with SMTP id b35so10676587iac.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2012 13:55:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1328542694-20777-1-git-send-email-sidhayn@gmail.com>
References: <1328542694-20777-1-git-send-email-sidhayn@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 7 Feb 2012 13:55:12 -0800
Message-ID: <CAB=NE6XcBa0T3p2_=Z0awoyfxQMLU51m-KDMQb3BTy=bcKFq0Q@mail.gmail.com> (sfid-20120207_225535_740622_F7D96A98)
Subject: Re: [PATCH] Calling make directly is not permitted
To: Rick Farina <sidhayn@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 6, 2012 at 7:38 AM, Rick Farina <sidhayn@gmail.com> wrote:
> make was being called directly, fix to $(MAKE)
>
> Signed-of-By: Rick Farina <sidhayn@gmail.com>

applied and pushed, thanks!

  Luis
