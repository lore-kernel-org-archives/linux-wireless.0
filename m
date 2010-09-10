Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:55980 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab0IJSoW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 14:44:22 -0400
Received: by gwj17 with SMTP id 17so1279736gwj.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Sep 2010 11:44:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100910050719.GA3959@vmraj-lnx.users.atheros.com>
References: <4C891102.40406@candelatech.com> <20100910050719.GA3959@vmraj-lnx.users.atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 10 Sep 2010 11:44:00 -0700
Message-ID: <AANLkTinfvgzTcZjOvzpbNm+fbwH3m-7jZgL9ktNKzh8D@mail.gmail.com>
Subject: Re: ath9k oops on rmmod
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 9, 2010 at 10:07 PM, Rajkumar Manoharan
<rmanoharan@atheros.com> wrote:
> The following commit solves the issue.
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8a2e8e5dec7e29c56a46ba176c664ab6a3d04118

Um, was this a stable fix?

  Luis
