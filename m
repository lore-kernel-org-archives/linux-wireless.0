Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.230]:12251 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758333AbXGYVx6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 17:53:58 -0400
Received: by wx-out-0506.google.com with SMTP id h31so307348wxd
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2007 14:53:57 -0700 (PDT)
Message-ID: <1ba2fa240707251453j6b13f5afo855e062e8ad15aa1@mail.gmail.com>
Date: Thu, 26 Jul 2007 00:53:57 +0300
From: "Tomas Winkler" <tomas.winkler@intel.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: Please pull patch-bomb for iwlwifi
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Zhu Yi" <yi.zhu@intel.com>, linux-wireless@vger.kernel.org
In-Reply-To: <46A7C01F.2050308@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <20070725085754.GA670@mail.intel.com>
	 <20070725200721.GH7093@tuxdriver.com>
	 <1ba2fa240707251400l784cbad7ja0003b24017c6535@mail.gmail.com>
	 <46A7C01F.2050308@garzik.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/26/07, Jeff Garzik <jeff@garzik.org> wrote:
> Tomas Winkler wrote:
> > I know you've asked us to review the already submitted 11n/HT patches.
> > I'm suggesting that we just patch over them otherwise we lost driver
> > stability and delay the whole process even more.  I'm not happy with
> > this solution myself but to bring the complete solution at once will
> > make us silent for another period.
>
>
> What do you mean, "patch over them"?
>
> If this means dual solutions for the same problem, it's not very enticing.
>
No, I mean gradually cleaning up the patches. Theoretically first I
want to change data structures, then the interfaces, and finally
cleaning up flows. but in bottom line I cannot afford to lost
stability of the whole project for the period it takes to fix,
currently driver works. Or first solution was narrowed to STA and we
want to make it works better in IBSS and AP mode as well.
I guess the community doesn't really care about our internal
constrains but we all live in time and space.

Tomas

>         Jeff
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
