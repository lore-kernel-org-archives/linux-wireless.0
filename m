Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:64622 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab0JGWiK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 18:38:10 -0400
Received: by qyk10 with SMTP id 10so438771qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Oct 2010 15:38:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201009250002.21219.chunkeey@googlemail.com>
References: <201009210057.13297.chunkeey@googlemail.com>
	<20100924180013.GD8077@tuxdriver.com>
	<201009250002.21219.chunkeey@googlemail.com>
Date: Thu, 7 Oct 2010 15:38:08 -0700
Message-ID: <AANLkTinCkWGs_KMz+QBUw2J5HUVU2hK1+8kVDr_PNZwP@mail.gmail.com>
Subject: Re: [RFC v2] mac80211: fix possible null-pointer dereference
From: Steve deRosier <steve@cozybit.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org, Javier Cardona <javier@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 24, 2010 at 3:02 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> ---
> anyway here's my new fix (this time RFC). Is there anyone at
> cozybits who can review the logic in the new patch?
>

Christian,

Javier and I reviewed the patch and it definitely fixes a potential
problem and is correct.  Furthermore, applied to wireless-testing
head, it passes all of our cases in our test bed.

I think it's good to go.

- Steve
