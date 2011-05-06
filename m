Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37642 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab1EFFFJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 01:05:09 -0400
Received: by wya21 with SMTP id 21so2129587wya.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 May 2011 22:05:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DC2C743.9060004@01019freenet.de>
References: <4DC2C743.9060004@01019freenet.de>
Date: Fri, 6 May 2011 10:35:08 +0530
Message-ID: <BANLkTi=V2=UpZENHek37q2D43KZyeAiO-Q@mail.gmail.com> (sfid-20110506_070532_479189_C8F440B1)
Subject: =?windows-1252?Q?Re=3A_compile=2Derror_agg=2Dtx=2Ec=3A_error=3A_implicit_declarat?=
	=?windows-1252?Q?ion_of_function_=91kfree=5Frcu=92?=
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 5, 2011 at 9:20 PM, Andreas Hartmann
<andihartmann@01019freenet.de> wrote:
> Hello,
>
> since May, there is a compile error in compat-wireless (against kernel
> 2.6.34):
>
>
> compat-wireless-2011-05-04-p/net/mac80211/agg-tx.c: In function
> ‘___ieee80211_stop_tx_ba_session’:
> compat-wireless-2011-05-04-p/net/mac80211/agg-tx.c:158: error: implicit
> declaration of function ‘kfree_rcu’
> compat-wireless-2011-05-04-p/net/mac80211/agg-tx.c:158: error:
> ‘rcu_head’ undeclared (first use in this function)
> compat-wireless-2011-05-04-p/net/mac80211/agg-tx.c:158: error: (Each
> undeclared identifier is reported only once
> compat-wireless-2011-05-04-p/net/mac80211/agg-tx.c:158: error: for each
> function it appears in.)
> compat-wireless-2011-05-04-p/net/mac80211/agg-tx.c: In function
> ‘ieee80211_tx_ba_session_handle_start’:
> compat-wireless-2011-05-04-p/net/mac80211/agg-tx.c:317: error:
> ‘rcu_head’ undeclared (first use in this function)
> compat-wireless-2011-05-04-p/net/mac80211/agg-tx.c: In function
> ‘ieee80211_stop_tx_ba_cb’:
> compat-wireless-2011-05-04-p/net/mac80211/agg-tx.c:696: error:
> ‘rcu_head’ undeclared (first use in this function)
>
>
> See https://patchwork.kernel.org/patch/745352/

this patch seems to be applied in compat-wireless-2011-05-05 but I am
still getting the same compilation errors in 2.6.32-25. any other
fixes

thanks,
shafi

>
>
> Regards,
> Andreas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
