Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.243]:1999 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbZFPEdg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 00:33:36 -0400
Received: by an-out-0708.google.com with SMTP id d40so9670237and.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jun 2009 21:33:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3ace41890906151936s3f0d70fcx6f42bfddf07dd70e@mail.gmail.com>
References: <3ace41890906151936s3f0d70fcx6f42bfddf07dd70e@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 15 Jun 2009 21:33:18 -0700
Message-ID: <43e72e890906152133x49e8a072hfce9e48f82094f35@mail.gmail.com>
Subject: Re: vid/pid sorting patch? (Re: [PATCH] zd1211rw: adding 083a:e503 as
	a ZD1211B device)
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 15, 2009 at 7:36 PM, Hin-Tak Leung<hintak.leung@gmail.com> wrote:
> Hiya,
>
> The zd1211rw vid/pid list is getting a bit unruly - would it be
> acceptable to submit a non-code-changing patch just to sort the ids?
> It would just be tidier and make it easier to see what id is already
> in and what is not, and also make it obvious where new changes should
> be inserted. I know this affects git blame and other log searching
> usage so may not be entirely desirable.

Development on wireless-testing is always open, just send what you
have and don't worry about where it can get applied.

  Luis
