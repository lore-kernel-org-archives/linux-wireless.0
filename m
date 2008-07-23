Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.235]:50351 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbYGWNQG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 09:16:06 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2390829rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 06:16:05 -0700 (PDT)
Message-ID: <5a4c581d0807230616n5a8e7ecfm172cfe0bd8d11b7e@mail.gmail.com> (sfid-20080723_151613_792701_68480669)
Date: Wed, 23 Jul 2008 15:16:05 +0200
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Alessandro Guido" <ag@alessandroguido.name>
Subject: Re: [BUG] kernel BUG at net/core/dev.c:1328!
Cc: "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <d4b984a30807230057t319eca71g32262305bdb07582@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <d4b984a30807210914nd4d0db5yb7b93ca5143ff0d5@mail.gmail.com>
	 <20080721.092027.14394005.davem@davemloft.net>
	 <d4b984a30807220254t1aaf6ac4q874329966511b0c5@mail.gmail.com>
	 <20080722.155611.176476925.davem@davemloft.net>
	 <d4b984a30807230057t319eca71g32262305bdb07582@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 23, 2008 at 9:57 AM, Alessandro Guido
<ag@alessandroguido.name> wrote:
> I'm testing the latest Linus' git which includes your patch
> (2.6.26-06077-gc010b2f) and the problem is fixed.
>
> Thank you!

-git10 also has this fixed for me. Thanks,

--alessandro

 "Give me love / Or give me hate
 Give me anything that's not just ok"

 (Sophia, 'Weightless')
